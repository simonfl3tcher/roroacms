class Admin::ThemesController < AdminController

	include AdminRoroaHelper
	
	# lists all the avalible themes

	def index 
		@themes = get_theme_options
		# finds the current theme that is set in the admin panel
		@current = Setting.find_by_setting_name('theme_folder')[:setting]
	end

	# update the currently used theme

	def create
		# the theme used is set in the settings area - this does the update of the current theme used
		Setting.where("setting_name = 'theme_folder'").update_all('setting' => params[:theme])

		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice:  "Theme used was updated" }
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