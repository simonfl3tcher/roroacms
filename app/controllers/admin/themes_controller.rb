class Admin::ThemesController < AdminController

	include AdminRoroaHelper
	add_breadcrumb "Themes", :admin_themes_path, :title => "Back to themes"
	
	# lists all the avalible themes

	def index 
		# set title
		@title = "Themes"
		
		# finds the current theme that is set in the admin panel
		@current = Setting.get('theme_folder')
	end


	# update the currently used theme

	def create
		# the theme used is set in the settings area - this does the update of the current theme used
		Setting.where("setting_name = 'theme_folder'").update_all('setting' => params[:theme])

		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice:  "Theme used was updated. Please restart the server for the theme to fully install." }
		end
	end
	

	# remove the theme from the theme folder stopping any future usage.

	def destroy
		# remove the directory from the directory structure
		destory_theme params[:id]
		
		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice:  "Theme successfully was deleted" }
		end
	end

end