require 'rubygems'
require 'jquery-rails'
require 'kaminari'
require 'ancestry'
require 'devise'
require 'diffy'
require 'aws-sdk'
require 'redcarpet'
require 'twitter-bootstrap-rails'
require 'pg'

module Roroacms

  class << self
    mattr_accessor :append_menu
    self.append_menu = []
  end

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine

    isolate_namespace Roroacms

    DB = YAML.load_file(Dir.pwd + "/config/database.yml")

    require 'active_record'
    
    ActiveRecord::Base.establish_connection(
      adapter:  'postgresql',
      database: DB[Rails.env]['database'],
      username: DB[Rails.env]['username'],
      password: DB[Rails.env]['password'],
      host:     DB[Rails.env]['host']
    )
    
    config.to_prepare do
      Devise::SessionsController.layout "roroacms/login"
      Devise::SessionsController.layout "roroacms/login"
      Devise::RegistrationsController.layout "roroacms/login"
      Devise::ConfirmationsController.layout "roroacms/login"
      Devise::UnlocksController.layout "roroacms/login"
      Devise::PasswordsController.layout "roroacms/login"
      ApplicationController.helper(ActionView::Helpers::ThemeHelper) if File.exists?("#{Rails.root}/app/helpers/theme_helper.rb")
    end
    
    require "#{Roroacms::Engine.root}/app/helpers/roroacms/general_helper.rb"
    require "#{Roroacms::Engine.root}/app/helpers/roroacms/admin_roroa_helper.rb"
    require "#{Roroacms::Engine.root}/app/models/roroacms/setting.rb"

    initializer :assets do |config|
      
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/views/themes/#{Setting.get('theme_folder')}/assets/stylesheets"
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/views/themes/#{Setting.get('theme_folder')}/assets/javascripts"
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/views/themes/#{Setting.get('theme_folder')}/assets/images"
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/assets/images/roroacms"
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/assets/javascripts/roroacms" if Dir.exists?("#{Dir.pwd}/app/assets/javascripts/roroacms")
        Rails.application.config.assets.paths << "#{Dir.pwd}/app/assets/stylesheets/roroacms" if Dir.exists?("#{Dir.pwd}/app/assets/stylesheets/roroacms")
        Rails.application.config.assets.precompile += %w( roroacms/roroacms.js )  if File.exists?("#{Dir.pwd}/app/assets/javascripts/roroacms/roroacms.js")
        Rails.application.config.assets.precompile += %w( roroacms/roroacms.css ) if File.exists?("#{Dir.pwd}/app/assets/stylesheets/roroacms/roroacms.css")
        Rails.application.config.assets.precompile += ["theme.css", "theme.js", "theme.scss", "theme.coffee"]
        Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
                
    end

    config.assets.precompile += %w( *.js *.css )
    config.serve_static_assets = true

    config.i18n.default_locale = :en
    config.assets.initialize_on_precompile = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    I18n.enforce_available_locales = true

    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = false

  end

end
