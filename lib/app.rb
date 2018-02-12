$LOAD_PATH.push File.dirname(__FILE__)
$LOAD_PATH.push File.expand_path('../..', __FILE__)

require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'models/url'
require 'yaml'
require 'json'

class App < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end 
  
  register Sinatra::ActiveRecordExtension
 
  set :root, File.expand_path('../..', __FILE__)
  
  set :public_folder, "#{root}/public"

  set :views, File.join("#{root}", "views")

  set :database_file, "#{root}/database.yml"

  get "/" do
    erb :index
  end

  post "/url" do
    url = params[:url]
    halt 400 if params[:url].nil?

    record = Url.find_or_initialize_by({ url: Url.clean_url(url)})
    record.base_url = base_url

    if record.new_record?

      halt 422, "Cannot process request" if !record.save

    end

    erb :preview, :locals => { short: record.short, host: request.host }

  end

  get "/*" do
    short = params['splat']
    record = Url.find_by(short: short)
    if record
      record.increment!(:visit_count)
      redirect record.url
    else
      halt 404
    end
  end

  error 404 do
    send_file File.join(settings.public_folder, '404.html')
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['HTTP_HOST']}"
    end
  end

end
