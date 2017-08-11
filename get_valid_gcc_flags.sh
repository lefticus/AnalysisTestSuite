
#pwd
$1 -Q --help=warning | sed -e 's/^\s*\(\-\S*\)\s*\[\w*\]/\1/gp;d' | sort > /tmp/all_flags.txt
# wc /tmp/all_flags.txt
$1 empty.cpp `$1 -Q --help=warning | sed -e 's/^\s*\(\-\S*\)\s*\[\w*\]/\1 /gp;d' | tr -d '\n'` 2>&1 | sed -e 's/.*‘\(.*\)’.*/\1/' | sort > /tmp/bad_flags.txt
# wc /tmp/bad_flags.txt
comm -13 /tmp/bad_flags.txt /tmp/all_flags.txt > /tmp/valid_flags.txt
# wc /tmp/valid_flags.txt
/bin/echo -e "-Wtemplate\n-Wnamespaces\n-Wsystem-headers\n-Waggregate-return\n" | sort > /tmp/ignored_flags.txt
# wc /tmp/ignored_flags.txt
comm -13 /tmp/ignored_flags.txt /tmp/valid_flags.txt > /tmp/final_flags.txt
# wc /tmp/final_flags.txt
cat /tmp/final_flags.txt | tr '\n' ' '


