class Admin::EditorController < AdminController

	before_filter :authorize_admin


	def update_from_air


		render :inline => 'Well dome'

	end

end