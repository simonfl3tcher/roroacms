module Roroacms
  
  class SetupController < ApplicationController

	  layout "roroacms/setup"
    before_filter :check_setup

    helper Roroacms::AdminRoroaHelper
    include Roroacms::AdminRoroaHelper

    def index
  		  Setting.reload_settings
      	@settings = Setting.get_all
        @settings['site_url'] = root_url if @settings['site_url'].blank?
      	@title = I18n.t("generic.installation.one")
  	end

  	def create 
  	  # To do update this table we loop through the fields and update the key with the value.
      # In order to do this we need to remove any unnecessary keys from the params hash
      remove_unwanted_keys

      # loop through the param fields and update the key with the value
      validation = Setting.manual_validation(params)

      respond_to do |format|
        if validation.blank?
          Setting.save_data(params)
          clear_cache

          format.html { redirect_to administrator_setup_index_path, notice: I18n.t("controllers.admin.setup.general.success") }
        else
          format.html {
            # add breadcrumb and set title
            @settings = params
            @settings['errors'] = validation
            render action: "index"
          }
        end
      end

  	end

    def create_user
      @admin = Admin.new(administrator_params)
      @admin.access_level = 'admin'
      @admin.overlord = 'Y'
      
      respond_to do |format|
        if @admin.save
          Setting.save_data({setup_complete: 'Y'})
          clear_cache
          format.html { redirect_to admin_path, notice: I18n.t("controllers.admin.setup.general.success") }
        else
          format.html { render action: "administrator" }
        end
      end

    end

    def administrator
      @title = I18n.t("generic.installation.two")
      @admin = Admin.new
    end

  	def remove_unwanted_keys
      params.delete :utf8
      params.delete :authenticity_token
      params.delete :commit
      params.delete :redirect
    end

    def check_setup 
      @meta_translation = I18n.t("views.admin.layouts.admin.meta_title_installation")
      render_404 if Setting.get('setup_complete') == 'Y' && params[:action] != 'tour_complete'
    end

    def tour_complete 
      Setting.save_data({tour_taken: 'Y'})
      render :inline => 'complete'
    end

    private

    # Strong parameters

    def administrator_params
      params.require(:admin).permit(:email, :username, :password, :password_confirmation)
    end

  end

end