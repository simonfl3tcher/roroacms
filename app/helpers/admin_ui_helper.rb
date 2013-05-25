module AdminUiHelper

	def bulk_update_dropdown options

		@options = options
		render :partial => "admin/partials/bulk_update_dropdown" 

	end

	def pagination
		render :partial => 'admin/partials/pagination'

	end

	def back_button

	    html = link_to :back, :class => 'btn btn-mini pull-right'
	    html += '<i class="icon-arrow-left"></i>'
	   	
	   	return html.html_safe

	end

end