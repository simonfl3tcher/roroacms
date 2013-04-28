class UsersController < ApplicationController
		
	def index

	end

	def new
	    @user = User.new
	end

	def create
		@user = User.new(params[:user])

		respond_to do |format|
		  if @user.save
		  	session[:user_id] = @user.id
		    format.html { redirect_to profile_index_path, notice: 'Your account was successfully created.' }
		  else
		    format.html { render action: "new" }
		    # format.json { render json: @user.errors, status: :unprocessable_entity }
		  end
		end
	end
end