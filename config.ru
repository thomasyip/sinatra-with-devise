# /config.ru
# This file is used by Rack-based servers to start the application.

# For Rails
require ::File.expand_path('../config/environment',  __FILE__)

# For Sinatra   
require './slim/slim.rb'
# - Make sinatra play nice
use Rack::MethodOverride
disable :run, :reload


# Mapping
# -------

# Rest with Rails
map "/" do
  run MyApp::Application
end

# Anything urls starting with /slim will go to Sinatra
map "/slim" do

  # make sure :key and :secret be in-sync with initializers/secret_store.rb initializers/secret_token.rb
  use Rack::Session::Cookie, :key => '_common_session_id', :secret => 'a39a2a65c24d712453420c12ba16ac784cd35bf6e378e0e83d10cdac7aa089faa5be2bbdec29780f723d1c7d7b3d13b43eab9db7918cf9119fdc028fd1d1a87b'

  # Point Warden to the Sinatra App
  use Warden::Manager do |manager|
    manager.failure_app = AppMain
    manager.default_scope = Devise.default_scope
  end
   
  # Borrowed from https://gist.github.com/217362
  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = "POST"
  end

  run AppMain
end
