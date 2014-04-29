class PagesController < ApplicationController

	before_filter :rewrite_theme_helper
	before_filter :check_theme_folder


	# everything request that is not the /admin goes through PagesController

	# Include the necessary helpers to load the file, RoutingHelper does the routing of the url to the correct data
	include ViewHelper
	include RoutingHelper
	include GeneralHelper

	# theme helper for the theme
	helper ThemeHelper

	# a homepage is set in the admin panel, route_index_page will display this page. 
	# (params) is also passed in, for the search form which send a GET request to the homepage
	# if the necessary params exist then it will display the search results otherwise it will display the homepage

	def index
		route_index_page params
 	end


 	def show
 		redirect_to show_url params
 	end

 	# if the url has segments the application will run through the dynamic_page method.
 	# route_dynamic_page function will take the url and search for the correct data to display

	def dynamic_page
		add_breadcrumb "Home", :root_path, :title => "Home"
		route_dynamic_page params
	end
	

	# contact_form is used for the contact form displayed on the contact page. This will take the params
	# save and send and email with the details to the admin email address that is set in the admin panel

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

	def contact_form_params

	    params.permit(:name, :email, :subject, :message)
	end

end