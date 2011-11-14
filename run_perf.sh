#!/bin/bash
set -e
 
cd $1
time=`bundle exec rspec $1/perf/ | 
  awk '
    /^[A-Z]{3}+/ {prefix = "\x27"$0"\x27"}
    /  RUNTIME: / {print prefix","$2}
  '`
echo $time
