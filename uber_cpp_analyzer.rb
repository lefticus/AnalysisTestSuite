#!/usr/bin/env ruby
#


require 'optparse'
require 'tmpdir'
require 'open3'
require 'json'
require 'logger'
require 'set'

$logger = Logger.new "cpp_uber_analyzer.log", 10


original_formatter = Logger::Formatter.new
$logger.formatter = proc { |severity, datetime, progname, msg|
  sev = nil
  case severity
  when "DEBUG"
    sev = Logger::DEBUG
  when "INFO"
    sev = Logger::INFO
  when "ERROR"
    sev = Logger::ERROR
  when "FATAL"
    sev = Logger::FATAL
  when "WARN"
    sev = Logger::WARN
  else
    sev = Logger::Unknown
  end

  msg = msg.gsub(/\/\/\S+@github/, "//<redacted>@github")

  if !$current_log_devicename.nil?
    msg = "[#{$current_log_devicename}] #{msg}"
  end

  if !$current_log_deviceid.nil?
    msg = "[#{$current_log_deviceid}] #{msg}"
  end

  if !$current_log_repository.nil?
    msg = "[#{$current_log_repository}] #{msg}"
  end

  if $remote_logger
    $remote_logger.add(sev, msg, progname)
  end

  res = original_formatter.call(severity, datetime, progname, msg.dump)
  puts res
  res
}

$logger.info "#{__FILE__} starting"
$logger.debug "#{__FILE__} starting, ARGV: #{ARGV}"
$logger.debug "Logging to decent_ci.log"



Options = Struct.new(:tool, :working_dir, :project_dir)


module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

class Parser
  def self.parse(options)
    args = Options.new()

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: #{ARGV[0]} [options]"

      opts.on("-tNAME", "--tool=NAME", "Tool to execute") do |n|
        args.tool = n
      end

      opts.on("-wPATH", "--working-dir=PATH", "Path for temporary files") do |n|
        args.working_dir = n
      end

      opts.on("-pPATH", "--project-dir=PATH", "Path to CMake based project to analyze") do |n|
        args.project_dir= n
      end



      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end


options = Parser.parse ARGV


puts options.tool;

# originally from https://gist.github.com/lpar/1032297
# runs a specified shell command in a separate thread.
# If it exceeds the given timeout in seconds, kills it.
# Returns any output produced by the command (stdout or stderr) as a String.
# Uses Kernel.select to wait up to the tick length (in seconds) between 
# checks on the command's status
#
# If you've got a cleaner way of doing this, I'd be interested to see it.
# If you think you can do it with Ruby's Timeout module, think again.
def run_with_timeout(env, command, timeout=60*60*4, tick=2)
  out = ""
  err = ""
  begin
    # Start task in another thread, which spawns a process
    stdin, stdout, stderr, thread = Open3.popen3(env, command)
    # Get the pid of the spawned process
    pid = thread[:pid]
    start = Time.now

    while (Time.now - start) < timeout and thread.alive?
      # Wait up to `tick` seconds for output/error data
      rs, = Kernel.select([stdout, stderr], nil, nil, tick)
      # Try to read the data
      begin
        if !rs.nil?
          rs.each { |r|
            if r == stdout
              out << stdout.read_nonblock(4096)
            elsif r == stderr 
              err << stderr.read_nonblock(4096)
            end
          }
        end

      rescue IO::WaitReadable
        # A read would block, so loop around for another select
      rescue EOFError
        # Command has completed, not really an error...
        break
      end
    end
    # Give Ruby time to clean up the other thread
    sleep 1

    if thread.alive?
      # We need to kill the process, because killing the thread leaves
      # the process alive but detached, annoyingly enough.
      Process.kill("TERM", pid)
    end
  ensure
    stdin.close if stdin
    stdout.close if stdout
    stderr.close if stderr
  end
  return out.force_encoding("UTF-8"), err.force_encoding("UTF-8"), thread.value
end

def run_script(run_dir, commands, env={})
  allout = ""
  allerr = "" 
  allresult = 0

  commands.each { |cmd|
    full_cmd = "cd #{run_dir} && #{cmd}"

    $logger.debug("executing cmd: '#{full_cmd}'")

    if OS.windows?
      $logger.warn "Unable to set timeout for process execution on windows"
      stdout, stderr, result = Open3::capture3(env, full_cmd)
    else
      # allow up to 6 hours
      stdout, stderr, result = run_with_timeout(env, full_cmd, 60*60*6)
    end

    stdout.split("\n").each { |l| 
      $logger.debug("cmd: #{cmd}: stdout: #{l}")
    }

    stderr.split("\n").each { |l| 
      $logger.info("cmd: #{cmd}: stderr: #{l}")
    }

    if cmd != commands.last && result != 0
      $logger.error("Error running script command: #{stderr}")
      raise stderr
    end

    allout += stdout
    allerr += stderr

    if result && result.exitstatus
      allresult += result.exitstatus
    else
      # any old failure result will do
      allresult = 1 
    end
  }

  return allout, allerr, allresult
end

def get_sha(src_dir)
  run_script(src_dir, ["git rev-parse HEAD"])
end

def cmake_configure(src_dir, output_dir, generator, enable_compile_commands, env = {})
  run_script(output_dir, ["cmake #{src_dir} -G \"#{generator}\" #{ enable_compile_commands ? "-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=ON" : "" } "], env)
end

def with_compile_commands(src_dir, env={})
  Dir.mktmpdir { |dir|
    cmake_configure(src_dir, dir, "Unix Makefiles", true, env)
    yield File.join(dir, "compile_commands.json"), dir
  }
end

def with_configured_dir(src_dir, generator, env)
  Dir.mktmpdir { |dir|
    cmake_configure(src_dir, dir, generator, false, env)
    yield dir
  }
end

def build(dir, configuration)
  return run_script(dir, ["cmake --build . --config #{configuration}"])
end

def get_compile_commands(compile_commands)
  return JSON.load(File.open(compile_commands))
end


def get_include_dirs(commands)
  includes = Set.new()

  commands.each { |c|
    c["command"].scan(/-I(\S+)/) { |m|
      includes.add(m[0].to_s)
    }
  }

  return includes.to_a
end

def get_cpp_files(commands)
  files = Set.new()

  commands.each { |c|
    files.add(c["file"])
  }

  return files.to_a
end

def run_cppcheck(src_dir, bin)
  results = []

  with_compile_commands(src_dir) { |compile_commands, working_dir|

    commands = get_compile_commands(compile_commands)
    includes = get_include_dirs(commands).collect { |i| " -I " + i }.join("")
    files = get_cpp_files(commands).to_a.join(" ")


    out, err, result = 
      run_script(src_dir, ["#{bin} #{includes} #{files} --platform=win64 --enable=all --inconclusive --template '{\"file\": \"{file}\", \"line\": {line}, \"severity\": \"{severity}\", \"id\": \"{id}\", \"message\": \"{message}\"}'"])

    toolname = `#{bin} --version`.strip

    err.split("\n").each { |e| 
      begin
        obj = JSON.load(e)
        obj["file"] = File.absolute_path(obj["file"], src_dir)
        obj["tool"] = toolname
        results << obj
      rescue 
        $logger.error("Unable to parse cppcheck output: '#{e}'")
      end
    }
  }

  return results
end

def parse_gcc_clang_results(output, toolname)
  results = []

  output.split("\n").each { |e| 
    /(?<filename>.*):(?<linenumber>[0-9]+):(?<colnumber>[0-9]+): (?<messagetype>.+?): (?<message>.*)/ =~ e

    if !filename.nil? && !messagetype.nil? && messagetype != "info" && messagetype != "note"
      results << { "tool" => toolname, "file" => filename, "line" => linenumber, "column" => colnumber, "severity" => messagetype, "message" => message }
    end
  }

  return results
end


def run_clang_tidy(src_dir)
  with_compile_commands(src_dir, {"CXX"=>"clang++-5.0", "CC"=>"clang-5.0"}) { |compile_commands, working_dir|

    commands = get_compile_commands(compile_commands)
    files = get_cpp_files(commands).to_a.join(" ")

    out, err, result = 
      run_script(src_dir, ["clang-tidy-5.0 -p #{compile_commands} #{files} -checks=*,-google* -header-filter=.*"])

    return parse_gcc_clang_results(out, "clang-tidy")
  }
end


def run_clang_check(src_dir, analyze = false)
  with_compile_commands(src_dir, {"CXX"=>"clang++-5.0", "CC"=>"clang-5.0"}) { |compile_commands, working_dir|

    commands = get_compile_commands(compile_commands)
    files = get_cpp_files(commands).to_a.join(" ")

    out, err, result = 
      run_script(src_dir, ["clang-check-5.0 -p #{compile_commands} #{files} #{analyze ? "-analyze" : "" }"])

    return parse_gcc_clang_results(err, "clang-check#{ analyze ? "-analyze" : "" }")
  }
end

def run_metrix_pp(src_dir)
  results = []

  with_compile_commands(src_dir) { |compile_commands, working_dir|

    commands = get_compile_commands(compile_commands)
    files = get_cpp_files(commands).to_a.join(" ")

    run_script(working_dir, ["python /home/jason/Downloads/metrixplusplus-1.3.168/metrix++.py collect --sclent --sclc --scmn --scmns --sccc --sccmi  #{src_dir} "])

    out, err, result = 
      run_script(working_dir, ["python /home/jason/Downloads/metrixplusplus-1.3.168/metrix++.py limit --max-limit=std.code.complexity:cyclomatic:15"])

    out.split("\n").each { |e| 
      /(?<filename>.*):(?<linenumber>[0-9]+): (?<messagetype>.+?): (?<message>.*)/ =~ e

      if !filename.nil? && !messagetype.nil? && messagetype != "info" && messagetype != "note"
        results << { "tool" => "metrix++", "file" => filename, "line" => linenumber, "severity" => messagetype, "message" => message }
      end
    }
  }

  return results
end

def run_pmd_cpd(src_dir)
  results = []


  out, err, result = run_script(src_dir, ["/home/jason/Downloads/pmd-bin-5.3.3/bin/run.sh cpd --language cpp --minimum-tokens 100 --files .  "])


  numlines = 0
  dups = []

  out.split("\n").each { |e| 

    if numlines != 0
      /Starting at line (?<linenum>[0-9]+) of (?<filename>.*)/ =~ e

      if !linenum.nil? and !filename.nil?
        dups << { "file" => filename, "line" => linenum }
      else
        results << { "tool" => "pmd_cpd", "severity" => "copy-paste", "numlines" => numlines, "locations" => dups }
        dups = []
        numlines = 0
      end
    else
      /Found a (?<linecount>[0-9]+) line.*/ =~ e

      if !linecount.nil?
        numlines = linecount.to_i
      else
        numlines = 0
      end
    end
  }

  return results
end

def parse_msvc_results(output)
  results = []

  output.split("\n").each { |e|
    /\s*(?<filename>.*)\((?<linenumber>[0-9]+)\): (?<messagetype>\S+) (?<id>\S+): (?<message>.+) \[.*\]/ =~ e

    if !filename.nil? && !messagetype.nil? && messagetype != "info" && messagetype != "note"
      results << { "tool" => "msvc", "file" => filename, "line" => linenumber, "severity" => messagetype, "message" => message, "id" => id }
    end
  }

  return results

end

def run_msvc_analyze(src_dir, configuration)
  with_configured_dir(src_dir, "Visual Studio 14 2015",  {"CXXFLAGS"=>"/analyze", "CFLAGS"=>"/analyze"}) { |dir|
    out, err, result = build(dir, configuration)

    return parse_msvc_results(out)
  }
end

def run_gcc(src_dir, configuration)
  with_configured_dir(src_dir, "Unix Makefiles", {"CXX"=>"g++-6", "CC"=>"gcc-6", "CXXFLAGS"=>`./get_valid_gcc_flags.sh g++-6`}) { |dir|
    out, err, result = build(dir, configuration)

    return parse_gcc_clang_results(err, "g++-6")
  }
end

def run_clang(src_dir, configuration)
  with_configured_dir(src_dir, "Unix Makefiles", {"CXX"=>"clang++-5.0", "CC"=>"clang-5.0", "CXXFLAGS"=>"-Weverything"}) { |dir|
    out, err, result = build(dir, configuration)

    return parse_gcc_clang_results(err, "clang++-5")
  }
end


def run_msvc_64_analyze(src_dir, configuration)
  with_configured_dir(src_dir, "Visual Studio 14 2015 Win64",  {"CXXFLAGS"=>"/analyze", "CFLAGS"=>"/analyze"}) { |dir|
    out, err, result = build(dir, configuration)

    return parse_msvc_results(out)
  }
end


def try_and_log(&block)
  begin
    block.call
  rescue => e
    $logger.error("unable to run test #{e}")
  end
end

results = []

project_path = File.absolute_path(ARGV[0])

try_and_log { results.concat(run_cppcheck(project_path, "/usr/bin/cppcheck")) }
try_and_log { results.concat(run_cppcheck(project_path, "/usr/local/bin/cppcheck")) }
try_and_log { results.concat(run_clang_check(project_path)) }
try_and_log { results.concat(run_clang_check(project_path, true)) }
try_and_log { results.concat(run_clang_tidy(project_path)) }
try_and_log { results.concat(run_metrix_pp(project_path)) }
try_and_log { results.concat(run_pmd_cpd(project_path)) }
try_and_log { results.concat(run_msvc_analyze(project_path, "Debug")) }
try_and_log { results.concat(run_msvc_64_analyze(project_path, "Debug")) }
try_and_log { results.concat(run_gcc(project_path, "Debug")) }
try_and_log { results.concat(run_clang(project_path, "Debug")) }


puts(JSON.pretty_generate(results))

File.open("output.json", 'w') { |file| file.write(JSON.pretty_generate(results)) }

#get_include_dirs(File.absolute_path(ARGV[0]))
#
#




