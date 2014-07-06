class Admin::SettingsController < AdminController

  add_breadcrumb I18n.t("generic.settings"), :admin_settings_path, :title => I18n.t("controllers.admin.settings.general.breadcrumb_title")

  # This controller is used for the settings page. This simply relates to all of the settings that are set in the database

  def index
    Setting.reload_settings
    @settings = Setting.get_all
    set_title(I18n.t("generic.settings"))
  end


  def create
    # To do update this table we loop through the fields and update the key with the value.
    # In order to do this we need to remove any unnecessary keys from the params hash
    remove_unwanted_keys

    # loop through the param fields and update the key with the value
    validation = Setting.manual_validation(params)

    respond_to do |format|
      if validation.blank?
        Setting.save(params)
        clear_cache
        format.html { redirect_to admin_settings_path, notice: I18n.t("generic.success") }
      else
        format.html {
          # add breadcrumb and set title
          @settings = params
          @settings['errors'] = validation
          @settings['user_groups'] = @json.encode(@settings['user_groups'])
          add_breadcrumb I18n.t("controllers.admin.comments.edit.breadcrumb")
          render action: "index"
        }
      end
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
