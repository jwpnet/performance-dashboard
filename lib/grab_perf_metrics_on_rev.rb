require 'rubygems'
require 'json'
require 'awesome_print'


#regex matches
@test_name_re = /(^[A-Z]{3,} \w{3,} (from|to) \/\S+)/
@runtime_re = /^  RUNTIME: (\d+.\d+)/

#methods
def get_app_name(path)
  path.split('/').last
end

def get_runtimes
  output = `bundle exec rspec perf/`
  test_names = output.scan(@test_name_re).map {|out| out.first}
  runtimes = output.scan(@runtime_re).map {|out| out.first}

  runtime_hash = {}
  if test_names.length < runtimes.length then runtimes = runtimes[0..test_names.length-1] end
  test_names.each_with_index {|k, i| runtime_hash[k] = runtimes[i] }
  runtime_hash
end

def add_to_json(data_file_path, runtimes, rev)
  ts = rev
  if File.exists? data_file_path
    f = File.open(data_file_path).read
    data_file = JSON.parse f
  else
    data_file = {}
  end
  
  runtimes.each do |k, v|
    if data_file.keys.index(k).nil?
      data_file[k] = [].push [ts, v.to_f]
    else
      data_file[k].push [ts, v.to_f]
    end
  end
  write_file = File.new(data_file_path, "w+")
  write_file.puts data_file.to_json
end

#############

data_file_path = ARGV.first
if data_file_path.nil? then 
  puts "USAGE: ruby grab_perf_metrics.rb data_file_path.json"
  exit
end

cur_dir = Dir.pwd 
rev=`git log -1 --pretty='format:%h' HEAD` 
app_name = get_app_name(cur_dir)
runtimes = get_runtimes

add_to_json(data_file_path, runtimes, rev)
