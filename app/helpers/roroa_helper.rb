module RoroaHelper

	def children_loop hash = nil, type = nil
		
		abort '123123412'
	end

	def is_numeric?(obj) 
	   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
	end

	def get_templates
		hash = []
		
		Dir.glob("app/views/pages/template-*.html.erb") do |my_text_file|
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


end