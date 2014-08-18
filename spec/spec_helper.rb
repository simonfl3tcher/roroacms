ENV['RAILS_ENV'] ||= 'development'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'factory_girl_rails'
require 'launchy'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

	config.mock_with :rspec

	config.use_transactional_fixtures = true
	config.infer_base_class_for_anonymous_controllers = false

	config.fixture_path = "#{::Rails.root}/spec/fixtures"

	config.include Capybara::DSL
  	config.include FactoryGirl::Syntax::Methods
  	
  	config.infer_spec_type_from_file_location!

  	config.before(:each, type: :controller) { @routes = Roroacms::Engine.routes }
 	config.before(:each, type: :routing)    { @routes = Roroacms::Engine.routes }



end