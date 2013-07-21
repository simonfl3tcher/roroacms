module AdminRoroaHelper

	def is_numeric?(obj) 
	   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

	def get_theme_options
		hash = []
		Dir.glob("app/views/theme/*/") do |themes|
			opt = themes.split('/').last
			info = YAML.load(File.read("#{themes}theme.yml"))
			hash << info
		end
		return hash
	end

	def destory_theme(id)
		require 'fileutils'
		FileUtils.rm_rf("app/views/theme/#{id}")
	end

	def get_templates
		hash = []

		current_theme = Setting.find_by_setting_name('theme_folder')[:setting]

		Dir.glob("app/views/theme/#{current_theme}/template-*.html.erb") do |my_text_file|
			opt = my_text_file.split('/').last
			opt['template-'] = ''
			opt['.html.erb'] = ''
			hash << opt.titleize
		end

		return hash
	end

	def get_template_dropdown(cur)

		templates = get_templates
		str =''
		templates.each do |f|
			if f == cur
				str	+= "<option value='#{f}' selected='selected'>#{f}</option>"
			else
				str	+= "<option value='#{f}'>#{f}</option>"
			end

		end

		return str.html_safe

	end

	def upload_file(file)

		File.open(Rails.root.join('public', 'uploads', file.original_filename), 'w') do |file|
			file.write(file.read)
		end	

	end

	def is_overlord

		admin = Admin.find(session[:admin_id])

		if admin.overlord == 'Y'

			true

		else 	

			false

		end


	end

	def nested_table(options)
	  
	  options.map do |opt, sub_messages|
	  	@content = opt
	  	@sub = sub_messages
	    render('admin/partials/table_row')
	  end.join.html_safe

	end

	def ancestory_indent(cont)

		cont.ancestor_ids.length

		i = 0

		html = ''
		while i < cont.ancestor_ids.length  do
		   html += "<i class=\"icon-minus\"></i>"
		   i +=1
		end

		render :inline =>  html.html_safe

	end

	def site_url(url )

		if url 

			base_url = Setting.get('site_url')	

			return "#{base_url}#{url}"

		else 

			return Setting.get('site_url')		

		end 

	end 

	def theme_exists
		current_theme = Setting.find_by_setting_name('theme_folder')[:setting]


		if !Dir.exists?("app/views/theme/#{current_theme}/")

			html = "<div class='alert alert-danger'><strong>Warning!</strong> The current theme does not exist!</div>"
	    	render :inline => html.html_safe

		end

	end
end