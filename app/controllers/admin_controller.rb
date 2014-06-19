class AdminController < ApplicationController  

	# AdminController extends the ApplicationController 
	# but also includes any admin specific helpers and changes the general layout
	before_filter :load_title
	after_filter :save_title
	require 'differ'

	helper GeneralHelper
	helper AdminRoroaHelper
	helper AdminUiHelper
	include GeneralHelper
	include AdminRoroaHelper

	add_breadcrumb I18n.t("generic.home"), :admin_path, :title => I18n.t("generic.home")

	before_filter :authorize_admin
	before_filter :authorize_admin_access
  	layout "admin" 


	# checks to see if the admin logged in has the necesary rights, if not it will redirect them with an error message

	def authorize_admin_access
		Setting.reload_settings
		if !check_controller_against_user(params[:controller].sub('admin/', '')) && params[:controller] != 'admin/dashboard'
			redirect_to admin_path, flash: { error: I18n.t("controllers.admin.misc.authorize_admin_access_error") }
		end
	end

	def after_sign_out_path_for(resource_or_scope)
		clear_cache
		Admin.destroy_session session
		admin_login_index_path
	end

	# functions used to set the title instance variable in an admin controller

	# Updates and Sets the title instance variable
	# Params:
	# +str+:: title

	def set_title str = ''
		@title = str
	end

	def load_title 
		@title = session[:title] || ''
	end
	
	def save_title
		session[:title] = @title
	end

end