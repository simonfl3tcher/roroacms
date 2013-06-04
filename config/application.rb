require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'rubygems'
require 'gattica'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Railsoverview
  class Application < Rails::Application
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end


# require File.expand_path('../boot', __FILE__)

# require 'rails/all'

# Bundler.require(:default, Rails.env) if defined?(Bundler)

# module Railsoverview
#   class Application < Rails::Application
#     config.encoding = "utf-8"
#     config.filter_parameters += [:password]


#     # AWS::S3::Base.establish_connection!(
#     #   :access_key_id     => 'AKIAI4VD2NT6NMGJLCOQ',
#     #   :secret_access_key => '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'
#     # )

#     BUCKET = 'roroa'

#     config.active_support.escape_html_entities_in_json = true
#     config.active_record.whitelist_attributes = true
#     config.assets.enabled = true
#     config.assets.version = '1.0'
#   end
# end
