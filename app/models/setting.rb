class Setting < ActiveRecord::Base
	
	# get a certain settings value

	def self.get(setting_name)
		@reference ||= filter_settings
		return setting_name == 'user_groups' ? @reference[setting_name].gsub("\\", '') : @reference[setting_name]
	end

	def self.get_all
		@reference
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
		h = {}
		Setting.all.each do |f|
			h[f.setting_name] = f.setting
		end
		h
	end

	def self.manual_validation(params)

		validate_arr = [:articles_slug, :category_slug, :tag_slug, :smtp_username, :smtp_password, :smtp_authentication]
		errors = {}
		validate_arr.each do |f|
			if defined?(params[f.to_s]) && params[f.to_s].blank?
				errors[f.to_sym] = "#{I18n.t("views.admin.settings.tab_content.#{f.to_s}")} #{I18n.t('generic.cannot_be_blank')}"
			end
		end
		errors
	end

	def self.save(params)

		params.each do |key, value|
			value = ActiveSupport::JSON.encode(value) if key == 'user_groups'
			set = Setting.where("setting_name = ?", key).update_all('setting' => value)
		end

		Setting.reload_settings
		
	end


	# reload the settings instance variable - this is used on the settings update function

	def self.reload_settings
		@reference = filter_settings
	end


	# build and return a hash of the SMTP settings via the settings in the admin panel.
	# this stops you having to change the settings in the config file and having to reload the application.

	def self.mail_settings
		case Setting.get('smtp_authentication')
			when 'plain'
				sym = :plain
			when 'login'
				sym = :login
			when 'cram_md5'
				sym = :cram_md5
			else
				sym = :plain
			end
		{ 
			:address 	=> Setting.get('smtp_address'), 
			:domain 	=> Setting.get('smtp_domain'), 
			:port 		=> Setting.get('smtp_port').blank? ? '25' : Setting.get('smtp_port'), 
			:user_name 	=> Setting.get('smtp_username'), 
			:password 	=> Setting.get('smtp_password'),
			:authentication => sym
		}
	end

end