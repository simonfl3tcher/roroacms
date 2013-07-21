class Setting < ActiveRecord::Base

	def self.get(setting_name)
		return Setting.find_by_setting_name(setting_name)[:setting]
	end

	def self.get_pagination_limit
		return Setting.get('pagination_per').to_i
	end

end