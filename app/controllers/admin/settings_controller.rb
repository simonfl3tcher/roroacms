class Admin::SettingsController < AdminController

	add_breadcrumb I18n.t("controllers.admin.settings.general.title"), :admin_settings_general_index_path, :title => I18n.t("controllers.admin.settings.general.breadcrumb_title")

	# This controller is used for the settings page. This simply relates to all of the settings that are set in the database


	def index 
		@title = I18n.t("controllers.admin.settings.general.title")
	end


	def create
		redirect = params[:redirect]

		# To do update this table we loop through the fields and update the key with the value. 
		# In order to do this we need to remove any unnecessary keys from the params hash
		remove_unwanted_keys


		# loop through the param fields and update the key with the value
		params.each do |key, value|
			value = @json.encode(value) if key == 'user_groups'
			set = Setting.where("setting_name = '#{key}'").update_all('setting' => value)
		end

		redirect_url = "admin_settings_path"

		respond_to do |format|
			format.html { redirect_to send(redirect_url), notice: I18n.t("controllers.admin.settings.general.create.flash.success") }
		end
	end


	def create_user_group
		@key = params[:key]
		print render :partial => 'admin/partials/user_group_view'
	end


	private

	# removes any unnecessary param field ready for the loop in the create function 

	def remove_unwanted_keys
		params.delete :utf8
		params.delete :authenticity_token
		params.delete :commit
		params.delete :redirect
	end

	
	# Strong parameters

	def settings_params
		params.permit(:setting_name, :setting)
	end

end