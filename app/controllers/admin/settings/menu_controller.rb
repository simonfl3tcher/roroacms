class Admin::Settings::MenuController < AdminController

	before_filter :authorize_admin

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
		    format.html { redirect_to admin_menu_index_path, notice: 'Menu Group was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end

		end

	end

	def menu_params
		if !session[:admin_id].blank?
			params.require(:menu).permit(:name, :key, :content)
		end
	end

	def destory 


	end


end