class Installation::InstallController < ApplicationController
	layout "install" 
	
	def index 

	end

	def create 

		remove_unwanted_keys

		params.each do |key, value|
			set = Setting.where("setting_name = '#{key}'").update_all('setting' => value)
		end

		redirect_url = "admin_settings_#{redirect}_index_path"

		respond_to do |format|
			format.html { redirect_to send(redirect_url), notice:  "Settings were updated" }
		end

	end

	def remove_unwanted_keys

		params.delete :utf8
		params.delete :authenticity_token
		params.delete :commit
		params.delete :redirect

	end

end