$LOAD_PATH.push File.dirname(__FILE__)

require 'sinatra/base'

class App < Sinatra::Base

  set :root, File.expand_path('../..', __FILE__)
  
  set :public_folder, "#{root}/public"

end
