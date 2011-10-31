APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'sinatra'
require 'warden'
require 'json'

# =============
#    Const
# =============
RACK_ENV = "#{ENV['RACK_ENV']}".downcase

EMPTY_JSON = JSON.generate({})

class AppMain < Sinatra::Application
  set :root, APP_ROOT

  get '/' do
    redirect '/app.html'
  end

  get '/protected' do
    if env['warden'].unauthenticated?
      halt 401, "User is not logged in."
    end
    
    'Hello World'
  end

  # -------------
  #     Auth
  # -------------
  post '/unauthenticated/?' do
    options = env['warden.options'] || {}
    code = options[:code] || 401
    message = options[:message] || 'Unauthorized'
      
    json = {
      :code => code,
        :message => message,
        :options => options
    }
    halt code, JSON.generate(json)
  end

  get '/logout/?' do
    env['warden'].logout
    redirect '/app.html'
  end

end
