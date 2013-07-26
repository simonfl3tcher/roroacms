class Admin::AdministratorsController < AdminController

	before_filter :authorize_admin_access, :except => [:edit, :update]
		
	def index
		@admins = Admin.setup_and_search params
	end

	def edit
		@admin = Admin.find(params[:id])
		@action = 'update'
	end

	def update
	    @admin = Admin.find(params[:id])

	    respond_to do |format|
	      if @admin.update_attributes(administrator_params)
	        format.html { redirect_to edit_admin_administrator_path(@admin), notice: 'Admin was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @admin = Admin.find(params[:id])
	    @admin.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully deleted.' }
	    end

	end

	def new
	    @admin = Admin.new
	    @action = 'create'
	end

	def create
		@admin = Admin.new(administrator_params)

		respond_to do |format|
		  if @admin.save
		  	Notifier.profile(@admin).deliver
		    format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end
	
	private

	def administrator_params
		if !session[:admin_id].blank?
			params.require(:admin).permit(:email, :password, :first_name, :last_name, :username, :access_level, :password_confirmation, :avatar, :inline_editing, :description)
		end
	end

end