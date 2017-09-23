#!/usr/bin/env ruby
#

require 'json'
require 'csv'


tablename = ARGV[0]


#puts "Reading table: '#{tablename}' from: '#{filename}'"

if ARGV[0].nil? || ARGV[1].nil?
  puts "Error: must provide both a tablename and a filename"
end


tablefound = false

ARGV.slice(1..-1 ).each.each_with_index { |filename, index|
  GC.start()
  
  JSON.parse(File.read(filename)).each{ |entry|

    if entry["type"] == tablename
      if !tablefound 
        puts ["sequence_number"].concat(entry.sort.to_h.keys).to_csv
        tablefound = true
      end

      puts [index].concat(entry.sort.to_h.values).to_csv
    end
  }

}


