require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Roroacms
  class Application < Rails::Application
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.assets.initialize_on_precompile = false

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    #config.active_record.whitelist_attributes = false

    # Enable the asset pipeline
    config.assets.enabled = true
    
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.action_controller.include_all_helpers = true
    config.assets.paths << Rails.root.join("vendor").to_s
  end
end
