class Admin::UsersController < AdminController
		
	def index
		@users = User.all
		if params.has_key?(:search)
			@users = User.where("email like ? or first_name like ? or last_name like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
		end
	end

	def edit 
		@user = User.find(params[:id])
	end

	def update
	    @user = User.find(params[:id])

	    respond_to do |format|
	      if @user.update_attributes(params[:user])
	        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @user = User.find(params[:id])
	    @user.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_users_path }
	    end

	end

	def new
	    @user = User.new
	end

	def create
		@user = User.new(params[:user])

		respond_to do |format|
		  if @user.save
		  	session[:user_id] = @user.id
		    format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end
end