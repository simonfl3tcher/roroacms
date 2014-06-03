class Setting < ActiveRecord::Base

	# get a certain settings value

	def self.get(setting_name)
		@reference ||= filter_settings
		return @reference[setting_name]
	end


	# get pagination setting for models

	def self.get_pagination_limit
		return Setting.get('pagination_per').to_i
	end


	def self.get_pagination_limit_fe
		return Setting.get('pagination_per_fe').to_i
	end


	# create a hash of the details for easy access via the get function

	def self.filter_settings()
		h = {}
		Setting.all.each do |f|
			h[f.setting_name] = f.setting
		end
		h
	end


	# reload the settings instance variable - this is used on the settings update function

	def self.reload_settings
		@reference = filter_settings
	end


	# build and return a hash of the SMTP settings via the settings in the admin panel.
	# this stops you having to change the settings in the config file and having to reload the application.

	def self.mail_settings
		{ 
			:address 	=> Setting.get('smtp_address'), 
			:domain 	=> Setting.get('smtp_domain'), 
			:port 		=> Setting.get('smtp_port').blank? ? '25' : Setting.get('smtp_port'), 
			:user_name 	=> Setting.get('smtp_username'), 
			:password 	=> Setting.get('smtp_password'),
			:authentication => Setting.get('smtp_authentication').to_sym
		}
	end

end