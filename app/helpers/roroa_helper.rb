module RoroaHelper

	def is_numeric?(obj) 
	   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end


	def get_templates
		hash = []
		
		Dir.glob("app/views/theme/template-*.html.erb") do |my_text_file|
			opt = my_text_file.split('/').last
			opt['template-'] = ''
			opt['.html.erb'] = ''
			hash << opt.titleize
		end

		return hash
	end

	def get_template_dropdown cur

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

	def upload_file file

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

end