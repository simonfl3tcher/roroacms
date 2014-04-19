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

		@message = ContactForm.new(contact_form_params)
		session[:return_to] = request.referer
		
		respond_to do |format|
		  
		  if @message.save

		  	EmailContactFormWorker.perform_async(@message.id)
		    format.html { redirect_to "#{session[:return_to]}", notice: "Your message has been sent successfully thank you." }

		  else

		  	flash[:error] = 'You missed out some required fields. Please try again.'
		    format.html { redirect_to "#{session[:return_to]}" }

		  end
		  
		end

	end

end