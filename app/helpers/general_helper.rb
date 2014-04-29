module GeneralHelper

	def theme_yaml key = nil 
		theme_yaml = YAML.load(File.read("#{Rails.root}/app/views/theme/#{current_theme}/theme.yml"))
		theme_yaml[key]
	end

end
