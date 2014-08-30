module Roroacms   
  class Setting < ActiveRecord::Base

    include GeneralHelper
    include AdminRoroaHelper

    after_save :after_reload_settings

    # get a certain settings value
    # Params:
    # +setting_name+:: the setting name that you want to return

    def self.get(setting_name)
      @reference ||= filter_settings
      ret = @reference[setting_name]
      ret = @reference[setting_name].gsub("\\", '') if setting_name == 'user_groups'
      ret
    end

    def self.get_all
      @reference = filter_settings
    end


    # get pagination setting for models

    def self.get_pagination_limit
      return Setting.get('pagination_per').to_i
    end


    def self.get_pagination_limit_fe
      return Setting.get('pagination_per_fe').to_i
    end


    # create a hash of the details for easy access via the get function

    def self.filter_settings
      begin
        h = {}
        Setting.all.each do |f|
          h[f.setting_name] = f.setting
        end
        h
      rescue => e
        {}
      end
    end

    # manually validates the settings area as it is not stored in the tradiaitonal rails way
    # Params:
    # +params+:: the parameters

    def self.manual_validation(params)

      validate_arr = [:site_url, :articles_slug, :category_slug, :tag_slug, :aws_access_key_id, :aws_secret_access_key, :aws_bucket_name, :url_prefix]
      errors = {}
      validate_arr.each do |f|
        if defined?(params[f.to_s]) && !params[f.to_s].nil?  && params[f.to_s].blank?
          errors[f.to_sym] = "#{I18n.t("views.admin.settings.tab_content.#{f.to_s}")} #{I18n.t('generic.cannot_be_blank')}"
        end
      end
      errors
    end


    # save the settings to the settings table
    # Params:
    # +params+:: the parameters

    def self.save_data(params)

      params.each do |key, value|
        value = ActiveSupport::JSON.encode(user_group_check(value)) if key == 'user_groups'
        value = Setting.strip_url(value) if key == 'site_url'
        value = value.gsub(/[^0-9]/i, '') if key == 'pagination_per_fe'
        set = Setting.where("setting_name = ?", key).update_all('setting' => value)
      end

      Setting.reload_settings

    end

    def self.user_group_check(hash)
      h = []
      Setting.list_controllers.each do |k,v|
        h << v
      end
      hash['admin'] = h
      hash.keys.sort
      return hash
    end


    # reload the settings instance variable - this is used on the settings update function

    def after_reload_settings
      @reference = Setting.filter_settings
    end

    def self.reload_settings
       @reference = Setting.filter_settings
    end

    def self.list_controllers(dir = 'admin')
      hash = {}
      controllers = Setting.list_controllers_raw(dir)

      controllers.each do |f|

        key = f.sub("#{Roroacms::Engine.root}/app/controllers/roroacms/admin/", '')
        value = key.sub('_controller.rb', '')

        next if value == 'dashboard'

        v =
          case value
          when 'settings/general'
            'Settings'
          when 'terms'
            'Categories & Tags'
          when 'posts'
            'Articles'
          when 'administrators'
            'Users'
          else
            value
          end
        v = v.split(' ').select {|w| w.capitalize! || w }.join(' ')
        hash[v] = key.sub('_controller.rb', '')

      end

      hash.sort
    end


    # list controllers in given directory
    # Params:
    # +dir+:: directory that you want to list all of the controllers from

    def self.list_controllers_raw(dir = "")
      dir = dir + "/**/" if !dir.blank?
      controller_list = Array.new
      Dir["#{Roroacms::Engine.root}/app/controllers**/roroacms/#{dir}*.rb"].each do |file|
        controller_list.push(file.split('/').last.sub!("_controller.rb",""))
      end
    end


    def self.strip_url(url)
      return url if url.blank?

      url.sub!(/www./, '')        if url.include? "www."
      
      url.sub!(/https\:\/\//, '') if url.include? "https://"

      url.sub!(/http\:\/\//, '')  if url.include? "http://"

      url = url[0...-1] if url[-1, 1] == '/'

      return url
    end


    # build and return a hash of the SMTP settings via the settings in the admin panel.
    # this stops you having to change the settings in the config file and having to reload the application.

    def self.mail_settings
      sym = 
        case Setting.get('smtp_authentication')
        when 'plain' then :plain
        when 'login' then :login
        when 'cram_md5' then :cram_md5
        else :plain
        end

        {
          :address 	=> Setting.get('smtp_address'),
          :domain 	=> Setting.get('smtp_domain'),
          :port 		=> Setting.get('smtp_port').blank? ? 25 : Setting.get('smtp_port').to_i,
          :user_name 	=> Setting.get('smtp_username'),
          :password 	=> Setting.get('smtp_password'),
          :authentication => sym
        }

    end

  end
end