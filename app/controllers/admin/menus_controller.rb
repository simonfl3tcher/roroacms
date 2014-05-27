class Admin::MenusController < AdminController

	add_breadcrumb "Menus", :admin_menus_path, :title => "Back to menus"

	# include the helper in the view
	helper AdminMenuHelper

	# list out the current menus and also create a new menu object 
	# for the form to create a new menu object if desired

	def index
		# set title
		@title = 'Menus'
		@menu = Menu.new
	end


	# create a new (empty) menu object from the form on the index page.

	def create
		@menu = Menu.new(menu_params)

		respond_to do |format|

		  if @menu.save
		    format.html { redirect_to edit_admin_menu_path(@menu), notice: 'Menu Group was successfully created.' }
		  else
		    format.html { 
			  	@menugroups = Menu.all
			  	@title = 'Menus'
		    	render action: "index" 
		    }
		  end

		end
	end


	# get menu object and display it for editing

	def edit
		@menu = Menu.find(params[:id])

		# add breadcrumb and set title
		add_breadcrumb 'Edit "' +  @menu.name + '" Menu'
		@title = 'Edit "' +  @menu.name + '" Menu'
	end


	# saves the menu on the fly via ajax. This usually gets called if there is any change to the menu object

	def save_menu
		if Menu.save_menu_on_fly params
			render :inline => 'done'
		end
	end


	# when you add an option to the menu this creates an edit form to allow you to edit the option straight away

	def ajax_dropbox 
		print render :partial => 'admin/menus/partials/menu_dropdown'
	end


	# deletes the whole menu. Although there is a delete button on each menu option this just removes it from the list 
	# which is then interpreted when you save the menu as a whole.

	def destroy 
		@menu = Menu.find(params[:id])
	    @menu.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_menus_path, notice: "Menu group successfully deleted." }
	    end
	end

	private 
	

	# Strong parameters

	def menu_params
		if !session[:admin_id].blank?
			params.require(:menu).permit(:name, :key, :content)
		end
	end

end