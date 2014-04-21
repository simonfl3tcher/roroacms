class Admin::ThemesController < AdminController

	include AdminRoroaHelper
	
	def index 
		@themes = get_theme_options
		@current = Setting.find_by_setting_name('theme_folder')[:setting]
	end

	def create 
		Setting.where("setting_name = 'theme_folder'").update_all('setting' => params[:theme])
		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice:  "Theme used was updated" }
		end
	end

	def destroy

		destory_theme params[:id]
		
		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice:  "Theme used was deleted" }
		end
	end

end