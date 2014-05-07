class AdminController < ApplicationController  

	# AdminController extends the ApplicationController 
	# but also includes any admin specific helpers and changes the general layout

	helper AdminRoroaHelper
	helper AdminUiHelper

	before_filter :authorize_admin
  	layout "admin" 

  	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :username, :access_level, :avatar, :access_level, :inline_editing, :overlord) }
	end

end