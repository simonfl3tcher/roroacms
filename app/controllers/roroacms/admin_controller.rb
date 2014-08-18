require_dependency "roroacms/application_controller"

module Roroacms
  
  class AdminController < ApplicationController

    # AdminController extends the ApplicationController
    # but also includes any admin specific helpers and changes the general layout
    before_filter :load_title
    after_filter :save_title

    helper Roroacms::GeneralHelper
    helper Roroacms::AdminRoroaHelper
    helper Roroacms::AdminUiHelper
    helper Roroacms::AdminViewHelper
    include Roroacms::GeneralHelper
    include Roroacms::MediaHelper
    include Roroacms::AdminRoroaHelper
    include Roroacms::AdminViewHelper

    add_breadcrumb I18n.t("generic.home"), '/admin', :title => I18n.t("generic.home")

    before_filter :authorize_admin
    before_filter :authorize_admin_access
    layout "roroacms/admin"


    # checks to see if the admin logged in has the necesary rights, if not it will redirect them with an error message

    def authorize_admin_access
      Setting.reload_settings
      if !check_controller_against_user(params[:controller].sub('roroacms/admin/', '')) && params[:controller] != 'roroacms/admin/dashboard' && params[:controller].include?('roroacms')
        redirect_to admin_path, flash: { error: I18n.t("controllers.admin.misc.authorize_admin_access_error") }
      end
    end
    

    def after_sign_out_path_for(resource_or_scope)
      clear_cache
      Admin.destroy_session session
      admin_login_index_path
    end

    # functions used to set the title instance variable in an admin controller

    # Updates and Sets the title instance variable
    # Params:
    # +str+:: title

    def set_title(str = '')
      @title = str
    end

    def load_title
      @title = session[:title] || ''
    end

    def save_title
      session[:title] = @title
    end

  end

end
