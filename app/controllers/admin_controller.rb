class AdminController < ApplicationController  

	# AdminController extends the ApplicationController 
	# but also includes any admin specific helpers and changes the general layout
	require 'differ'

	helper GeneralHelper
	helper AdminRoroaHelper
	helper AdminUiHelper
	include GeneralHelper
	include AdminRoroaHelper

	add_breadcrumb I18n.t("controllers.admin.misc.dashboard_title"), :admin_path, :title => I18n.t("controllers.admin.misc.dashboard_breadcrumb_title")


	before_filter :authorize_admin
	before_filter :authorize_admin_access
  	layout "admin" 

  	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :username, :access_level, :avatar, :access_level, :overlord) }
	end

	# checks to see if the admin logged in has the necesary rights, if not it will redirect them with an error message

	def authorize_admin_access
		
		if !check_controller_against_user(params[:controller].sub('admin/', '')) && params[:controller] != 'admin/dashboard'
			flash[:error] = I18n.t("controllers.admin.misc.authorize_admin_access_error")
			redirect_to admin_path
		end

	end

end