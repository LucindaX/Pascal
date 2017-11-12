$LOAD_PATH.push File.dirname(__FILE__)
$LOAD_PATH.push File.expand_path('../..', __FILE__)

require 'sinatra/base'
require 'sinatra/activerecord'
require 'models/url'
require 'yaml'
require 'json'

class App < Sinatra::Base
  
  register Sinatra::ActiveRecordExtension
  
  set :root, File.expand_path('../..', __FILE__)
  
  set :public_folder, "#{root}/public"

  set :database_file, "#{root}/database.yml"

  post '/url' do
    url = params[:url]
    record = Url.find_or_initialize_by({ url: Url.clean_url(url) })
    if record.new_record?
      if record.save
        { short: record.short }.to_json
      else
        halt 422, "Could not process request"
      end
    else
      halt 303, { short: record.short }.to_json
    end
  end

  get '/*' do
    short = params['splat']
    record = Url.find_by(short: short)
    if record
      record.increment!(:visit_count)
      redirect record.url
    else
      halt 404, "Not Found"
    end
  end

end
