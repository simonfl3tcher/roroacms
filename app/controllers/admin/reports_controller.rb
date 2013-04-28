class Admin::ReportsController < AdminController

	before_filter :authorize_admin

	def index 
		@time = Time.now
	end
end