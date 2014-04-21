module AdminRoroaHelper

	# returns wether it is numeric or not
	# Params:
	# +obj+:: either an int, float, decimal or string of a number or not depending on what you are looking for

	def is_numeric?(obj) 
	   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

	# returns a hash of the different themes as a hash with the details kept in the theme.yml file

	def get_theme_options
		
		hash = []
		Dir.glob("app/views/theme/*/") do |themes|
			opt = themes.split('/').last
			info = YAML.load(File.read("#{themes}theme.yml"))
			hash << info
		end

		hash
	end

	# destroys the theme from the file structure
	# Params:
	# +theme+:: the theme name which is set in the theme.yml file and should be the same as the folder name

	def destory_theme(theme)
		require 'fileutils'
		FileUtils.rm_rf("app/views/theme/#{theme}")
	end

	# retuns a hash of the template files within the current theme

	def get_templates
		hash = []
		current_theme = Setting.find_by_setting_name('theme_folder')[:setting]

		Dir.glob("app/views/theme/#{current_theme}/template-*.html.erb") do |my_text_file|
			opt = my_text_file.split('/').last
			opt['template-'] = ''
			opt['.html.erb'] = ''
			# strips out the template- and .html.erb extention and returns the middle as the template name for the admin
			hash << opt.titleize
		end

		hash
	end

	# returns a html dropdown of the template options 
	# Params:
	# +current+:: current post template, if it doesn't have one it will just return a standard dropdown

	def get_template_dropdown(current = '')

		templates = get_templates
		str = ''

		templates.each do |f|
			if f == current
				str	+= "<option value='#{f}' selected='selected'>#{f}</option>"
			else
				str	+= "<option value='#{f}'>#{f}</option>"
			end
		end

		str.html_safe

	end

	# returns boolean as to wether the logged in user is the complete overlord of the system

	def is_overlord?
		admin = Admin.find(session[:admin_id])
		admin.overlord == 'Y' ? true : false
	end

	# returns a table block of html that has nested ootions
	# Params:
	# +options+:: is a hash of all of the record that you want to display in a nested table

	def nested_table(options)
		options.map do |opt, sub_messages|
			@content = opt
			# set the sub to be sub messages. The view checks its not blank and runs this function again 
			@sub = sub_messages

			render('admin/partials/table_row')

		end.join.html_safe
	end

	# returns a html block of line indentation to show that it is underneath its parent
	# Params:
	# +cont+:: a hash of the record you are checking against

	def ancestory_indent(cont)

		html = ''
		cont.ancestor_ids.length

		i = 0
		while i < cont.ancestor_ids.length  do
		   html += "<i class=\"icon-minus\"></i>"
		   i += 1
		end

		render :inline =>  html.html_safe

	end

	# returns the site url + an extention if you give it one
	# Params:
	# +ext+:: extension to add on to the end of the site url

	def site_url(ext)
		
		# if you do not give ext anything it will just return the standard site url

		if ext 
			base_url = Setting.get('site_url')	
			return "#{base_url}#{url}"
		else 
			return Setting.get('site_url')		
		end 

	end 

	# checks if the current theme being used actually exists. If not it will return an error message to the user

	def theme_exists
		
		current_theme = Setting.find_by_setting_name('theme_folder')[:setting]

		if !Dir.exists?("app/views/theme/#{current_theme}/")
			html = "<div class='alert alert-danger'><strong>Warning!</strong> The current theme being used does not exist!</div>"
	    	render :inline => html.html_safe
		end

	end

end