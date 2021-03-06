require File.expand_path('../config/perfdashboard', __FILE__)

class PerfDashboard < Sinatra::Base

  set :root, File.expand_path('../', __FILE__)
  set :sprockets, Sprockets::Environment.new(root)
  set :precompile, [/\w+\.(?!js|css).+/, /applcation.(css|js)$/]
  set :precomile, [/.*/]
  set :assets_prefix, 'assets'
  set :assets_path, File.join(root, 'public', assets_prefix)

  configure do
    sprockets.append_path(File.join(root, 'assets', 'javascripts'))
    sprockets.append_path File.expand_path('assets/stylesheets', settings.root)
    sprockets.append_path File.expand_path('assets/images', settings.root)

    sprockets.context_class.instance_eval do
      include AssetHelpers
    end
  end

  helpers do
    include AssetHelpers
  end

  get '/' do
    haml :index
  end

  get "/get_data/:app_name" do
    content_type :json
    data = JSON.parse File.open("#{DATA_DIR}/#{params[:app_name]}_dashboard_data.json").read

    data.to_json
  end
end
