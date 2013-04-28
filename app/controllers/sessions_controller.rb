class SessionsController < ApplicationController
		
	def create 
		# abort("doing this for you")
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to profile_index_url, notice: "Logged in!"
		else
			redirect_to profile_index_url, notice: "You are unable to login!!"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url, notice: "Logged Out!"
	end

	def new

	end

end