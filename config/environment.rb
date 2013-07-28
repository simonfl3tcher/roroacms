# Load the rails application
require File.expand_path('../application', __FILE__)
# Initialize the rails application
# config/environment.rb
 
Rails::Initializer.run do |config|  
  require 'yaml'
  
  # support yaml and heroku config vars, preferring ENV for heroku
  CONFIG = (YAML.load_file('config/config.yml')[RAILS_ENV] rescue {}).merge(ENV)
  
end
Roroacms::Application.initialize!
