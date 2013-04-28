class Admin::Settings::GeneralController < AdminController

	before_filter :authorize_admin
	before_filter :authorize_admin_access

	def index

	end

	def create

		redirect = params[:redirect]

		# this function is not used in the general REST way. Because it gets a number of different things from one table!! Be careful when altering these files
		
		remove_unwanted_keys

		params.each do |key, value|
			set = Setting.where("setting_name = '#{key}'").update_all('setting' => value)
		end

		redirect_url = "admin_settings_#{redirect}_index_path"

		respond_to do |format|
			format.html { redirect_to send(redirect_url), notice:  "Settings were updated." }
		end
		
	end

	def show


	end

	private

	def remove_unwanted_keys

		params.delete :utf8
		params.delete :authenticity_token
		params.delete :commit
		params.delete :redirect

	end

end