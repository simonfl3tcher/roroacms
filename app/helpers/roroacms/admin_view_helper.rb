module Roroacms  
	module AdminViewHelper

		def obtain_admin_table_header(variables)
			render partial: 'roroacms/admin/partials/table_header', locals: variables
		end

		def obtain_admin_submit_bar
			render :partial => 'roroacms/admin/partials/submit_bar'
		end

		def obtain_admin_editor(variables)
			render :partial => 'roroacms/admin/partials/editor', locals: variables
		end

	end
end