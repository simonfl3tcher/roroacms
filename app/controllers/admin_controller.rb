class AdminController < ApplicationController  

	helper RoroaHelper
	helper AdminUiHelper
	helper GoogleAnalyticsHelper

	before_filter :authorize_admin
  	layout "admin" 
end