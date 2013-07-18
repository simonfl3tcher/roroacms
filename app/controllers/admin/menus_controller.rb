class Admin::MenusController < AdminController

	before_filter :authorize_admin
	helper AdminMenuHelper

	def index
		@menu = Menu.new
		@menugroups = Menu.all
	end

	def new
	    @menu = Menu.new
	end

	def create
		@menu = Menu.new(menu_params)

		respond_to do |format|
		  if @menu.save
		    format.html { redirect_to edit_admin_menu_path(@menu), notice: 'Menu Group was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end

		end

	end

	def edit
		@menu = Menu.find(params[:id])

	end

	def save_menu
		if Menu.save_menu_on_fly params
			render :inline => 'done'
		end
	end

	def ajax_dropbox 
		print render :partial => 'admin/partials/menu_dropdown'
	end

	def destroy 
		@menu = Menu.find(params[:id])
	    @menu.destroy
	    respond_to do |format|
	      format.html { redirect_to admin_menus_path, notice: "Menu group successfully deleted." }
	    end
	    
	end

	def menu_params
		if !session[:admin_id].blank?
			params.require(:menu).permit(:name, :key, :content)
		end
	end


end