# staging.rb, production.rb

# Log detail is configurable on the server
config.log_level = ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].to_sym : ('info').to_sym
