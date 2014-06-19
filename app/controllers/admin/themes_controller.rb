class Admin::ThemesController < AdminController

	include AdminRoroaHelper
	add_breadcrumb I18n.t("generic.title"), :admin_themes_path, :title => I18n.t("controllers.admin.themes.breadcrumb_title")
	
	
	# lists all the avalible themes

	def index 
		# set title
		set_title(I18n.t("generic.title"))
		
		# finds the current theme that is set in the admin panel
		@current = Setting.get('theme_folder')
	end


	# update the currently used theme

	def create
		# the theme used is set in the settings area - this does the update of the current theme used
		Setting.where("setting_name = 'theme_folder'").update_all('setting' => params[:theme])

		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice: I18n.t("controllers.admin.themes.create.flash.success") }
		end
	end

	
	# remove the theme from the theme folder stopping any future usage.

	def destroy
		# remove the directory from the directory structure
		destory_theme params[:id]
		
		respond_to do |format|
			format.html { redirect_to admin_themes_path, notice: I18n.t("controllers.admin.themes.destroy.flash.success") }
		end
	end

end