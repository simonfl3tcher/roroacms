module ThemeHelper
	
	def d
		render :inline => @content.post_content.html_safe
	end

end