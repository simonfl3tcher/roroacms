class PagesController < ApplicationController

	include ViewHelper
	include RoutingHelper

	def index

		route_index_page params

 	end

 	def show
 		redirect_to show_url params
 	end

	def dynamic_page

		add_breadcrumb "Home", :root_path, :title => "Home"
		
		route_dynamic_page params

	end

end