require 'rubygems'
require 'json'
require 'awesome_print'

#some important stuff...
@DATA_DIR= "data"
@JSON_FILE_FORMAT = "_dashboard_data.json"
@MAX_HISTORY = 24

#regex matches
@test_name_re = /(^[A-Z]{3,} \w{3,} (from|to) \/\S+)/
@runtime_re = /^  RUNTIME: (\d+.\d+)/

#methods
def get_app_name(path)
  path.split('/').last
end

def get_runtimes(path)
  Dir.chdir(path)
  output = `bundle exec rspec perf/`
  test_names = output.scan(@test_name_re).map {|out| out.first}
  runtimes = output.scan(@runtime_re).map {|out| out.first}

  runtime_hash = {}
  if test_names.length < runtimes.length then runtimes = runtimes[0..test_names.length-1] end
  test_names.each_with_index {|k, i| runtime_hash[k] = runtimes[i] }
  runtime_hash
end

def add_to_json(app_name, runtimes)
  ts = Time.now.to_i
  file_name = "#{@DATA_DIR}/#{app_name}#{@JSON_FILE_FORMAT}"
  if File.exists? file_name
    f = File.open(file_name).read
    data_file = JSON.parse f
  else
    data_file = {}
  end

  runtimes.each do |k, v|
    if data_file.keys.index(k).nil?
      data_file[k] = [].push [ts, v.to_f]
    else
      data_file[k].shift if data_file[k].length > @MAX_HISTORY
      data_file[k].push [ts, v.to_f]
    end
  end
  write_file = File.new(file_name, "w+")
  write_file.puts data_file.to_json
end

#############
app_paths = ARGV.map {|a| a }
if app_paths.empty? 
  puts "USAGE: ruby grab_perf_metrics.rb 'application path' 'application path2' ..."
  exit
end

app_paths.each do |path|
  cur_dir = Dir.pwd 
  app_name = get_app_name(path)
  runtimes = get_runtimes(path)
  Dir.chdir(cur_dir)

  add_to_json(app_name, runtimes)
end
