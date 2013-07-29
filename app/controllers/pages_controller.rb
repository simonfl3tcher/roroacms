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

	def contact_form
		session[:return_to] ||= request.referer
		Notifier.contact_form(params).deliver

		respond_to do |format|
			format.html { redirect_to "#{session[:return_to]}#contact_form", notice: "Your message has been sent successfully thank you." }
		end
	end

end