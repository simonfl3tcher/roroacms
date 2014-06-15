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
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.assets.initialize_on_precompile = true

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    #config.active_record.whitelist_attributes = false
    config.active_record.schema_format = :ruby
    # Enable the asset pipeline
    config.assets.enabled = true
    
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    config.action_controller.include_all_helpers = true
    config.i18n.default_locale = :en
    I18n.enforce_available_locales = true

    ENV = YAML.load_file("#{Rails.root}/config/config.yml")

    config.to_prepare do
      Devise::SessionsController.layout "login"
      Devise::SessionsController.layout "login"
      Devise::RegistrationsController.layout "login"
      Devise::ConfirmationsController.layout "login"
      Devise::UnlocksController.layout "login"
      Devise::PasswordsController.layout "login"
    end

    require 'active_record'
    require 'pg'
    DB = YAML.load_file("#{Rails.root}/config/database.yml")

    ActiveRecord::Base.establish_connection(
      adapter:  'postgresql',
      database: DB[Rails.env]['database'],
      username: DB[Rails.env]['username'],
      password: DB[Rails.env]['password'],
      host:     DB[Rails.env]['host']
    )
    require "#{Rails.root}/app/models/setting.rb"

    config.assets.paths << Rails.root.join("vendor", "assets", "externals").to_s
    config.assets.paths << "#{Rails.root}/app/views/theme/#{Setting.get('theme_folder')}/assets/stylesheets"
    config.assets.paths << "#{Rails.root}/app/views/theme/#{Setting.get('theme_folder')}/assets/javascripts"
    config.assets.paths << "#{Rails.root}/app/views/theme/#{Setting.get('theme_folder')}/assets/font"
    config.assets.paths << "#{Rails.root}/app/views/theme/#{Setting.get('theme_folder')}/assets/images"
  end
end
