class Admin::DashboardController < AdminController

	before_filter :authorize_admin

	def index 

	end

end