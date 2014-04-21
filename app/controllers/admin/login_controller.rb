class Admin::LoginController < LoginController
	
	# the login form is posted to this create function

	def create 
		admin = Admin.find_by_username(params[:username])
		
		# check to see if the details are correct
		if admin && admin.authenticate(params[:password])

			Admin.set_sessions session, admin
			redirect_to admin_url, notice: "Welcome #{admin.first_name}"

		else
			# If the details are incorrect then redirect back to the login page
			redirect_to admin_url, notice: "You are unable to login!!"
		end

	end

	# destroy function is used for login the user out of the admin panel

	def destroy
		Admin.destroy_session session
		redirect_to root_url, notice: "Logged Out!"
	end

end