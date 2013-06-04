class Admin::AdministratorsController < AdminController

	before_filter :authorize_admin_access, :except => [:edit, :update]
		
	def index
		@admins = Admin.all
		if params.has_key?(:search)
			@admins = Admin.where("email like ? or first_name like ? or last_name like ? or username like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
		end
	end

	def edit 
		@admin = Admin.find(params[:id])
		@action = 'update'
	end

	def update
	    @admin = Admin.find(params[:id])

	    respond_to do |format|
	      if @admin.update_attributes(params[:admin])
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
		@admin = Admin.new(params[:admin])

		respond_to do |format|
		  if @admin.save
		  	Notifier.profile(@admin).deliver
		    format.html { redirect_to admin_administrators_path, notice: 'Admin was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end

	def upload
	  	uploaded_io = params[:admin][:avatar]
	 	File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
	    file.write(uploaded_io.read)
	  end
	end
end