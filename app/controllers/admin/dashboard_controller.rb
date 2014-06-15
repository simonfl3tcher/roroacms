class Admin::DashboardController < AdminController

	# interface to the admin dashboard
	def index 
		@comments = latest_comments
	end

end