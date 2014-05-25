class Admin::AdministratorsController < AdminController

	# Make sure that only the super user is allowed to create new admin accounts. 
	# This is to stop people allowing themselves more access than they area allowed
	before_filter :authorize_admin_access, :except => [:edit, :update]

	include MediaHelper
	include AdminRoroaHelper

	add_breadcrumb "Users", :admin_administrators_path, :title => "Back to users"

	# show all of the admins for the system

	def index
		# set title
		@title = 'Users'
		@admins = Admin.setup_and_search params
	end


	# get and disply certain admin

	def edit
		@admin = Admin.find(params[:id])

		# add breadcrumb and set title
		@title = 'Profile - ' + @admin.first_name + ' ' + @admin.last_name
		add_breadcrumb "Edit User"
		
		# action for the form as both edit/new are using the same form.
		@action = 'update'

		# only allowed to edit the super user if you are the super user.
		if @admin.overlord == 'Y' && @admin.id != session[:admin_id]
			
			respond_to do |format|
				
				flash[:error] = "You are unable to edit the superuser administrator"
			 	format.html { redirect_to admin_administrators_path }
		    
		    end
		
		end
	end


	# update the admins object

	def update

	    @admin = Admin.find(params[:id])

	    @admin.deal_with_cover params


	    respond_to do |format|

	    	if params[:admin][:password].blank?
	    		admin_passed = @admin.update_without_password(administrator_params)
	    	else
	    		admin_passed = @admin.update_attributes(administrator_params)
	    	end

	      if admin_passed

	      	profile_images(params, @admin)
	        
	        format.html { redirect_to edit_admin_administrator_path(@admin), notice: 'Admin was successfully updated.' }
	      else
	      	@action = 'update'
	        format.html { render action: "edit" }
	      end

	    end

	end


	# Delete the admin, one thing to remember is you are not allowed to destory the super user.
	# You are only allowed to destroy yourself unless you are the super user.

	def destroy
	    @admin = Admin.find(params[:id])
	    @admin.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully deleted.' }
	    end
	end


	# create a new admin object

	def new
	    # add breadcrumb and set title
	    @title = 'Profile'
	    add_breadcrumb "Add New User"

	    @admin = Admin.new
	    @action = 'create'
	end


	# actually create the new admin with the given param data

	def create
		@admin = Admin.new(administrator_params)
		@admin.deal_with_abnormalaties

		respond_to do |format|
		  
		  if @admin.save

		  	profile_images(params, @admin)
		  	Notifier.profile(@admin).deliver

		    format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully created.' }

		  else
		  	@action = 'create'
		    format.html { render action: "new" }
		  end

		end
	end
	
	
	private

	# Strong parameters

	def administrator_params
		if !session[:admin_id].blank?
			params.require(:admin).permit(:email, :password, :first_name, :last_name, :username, :access_level, :password_confirmation, :description)
		end
	end

end