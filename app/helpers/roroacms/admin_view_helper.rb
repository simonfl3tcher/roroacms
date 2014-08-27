module Roroacms  
	module AdminViewHelper

		# There functions are used to recreate the views in the main application.

		# renders the table header file

		def obtain_admin_table_header(variables)
			render partial: 'roroacms/admin/partials/table_header', locals: variables
		end

		# renders the submit bar header file

		def obtain_admin_submit_bar
			render :partial => 'roroacms/admin/partials/submit_bar'
		end

		# renders the table editor file

		def obtain_admin_editor(variables)
			render :partial => 'roroacms/admin/partials/editor', locals: variables
		end

	end
end