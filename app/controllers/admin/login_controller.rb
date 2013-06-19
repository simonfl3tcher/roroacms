class Admin::LoginController < LoginController
		
	def create 
		admin = Admin.find_by_username(params[:username])
		if admin && admin.authenticate(params[:password])
			Admin.set_sessions session, admin
			redirect_to admin_url, notice: "Welcome #{admin.first_name}"
		else
			redirect_to admin_url, notice: "You are unable to login!!"
		end
	end

	def destroy
		Admin.destroy_session session
		redirect_to root_url, notice: "Logged Out!"
	end

end