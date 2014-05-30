class Setting < ActiveRecord::Base

	# get a certain settings value

	def self.get(setting_name)
		return Setting.find_by_setting_name(setting_name)[:setting]
	end

	# get pagination setting for models

	def self.get_pagination_limit
		return Setting.get('pagination_per').to_i
	end

	def self.get_pagination_limit_fe
		return Setting.get('pagination_per_fe').to_i
	end

	def self.mail_settings
		{ 
			:address 	=> Setting.get('smtp_address'), 
			:domain 	=> Setting.get('smtp_domain'), 
			:port 		=> Setting.get('smtp_port').blank? '25' : Setting.get('smtp_port'), 
			:user_name 	=> Setting.get('smtp_username'), 
			:password 	=> Setting.get('smtp_password'),
			:authentication => Setting.get('smtp_authentication').to_sym
		}
	end

end