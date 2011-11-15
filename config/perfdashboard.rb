SINATRA_ROOT = File.expand_path('../../', __FILE__)
DATA_DIR = 'data'

require 'bundler'
Bundler.require

module AssetHelpers
  def asset_path(source)
    "/assets/" + settings.sprockets.find_asset(source).digest_path
  end
end


