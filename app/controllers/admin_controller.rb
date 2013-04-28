class AdminController < ApplicationController  

	helper RoroaHelper


	before_filter :authorize_admin, :except=>[:upload]
  	layout "admin" 
end