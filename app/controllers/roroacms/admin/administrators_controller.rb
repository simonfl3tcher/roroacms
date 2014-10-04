module Roroacms
  
  class Admin::AdministratorsController < AdminController

    # Make sure that only the super user is allowed to create new admin accounts.
    # This is to stop people allowing themselves more access than they area allowed
    before_filter :authorize_admin_access, :except => [:edit, :update]

    add_breadcrumb I18n.t("generic.users"), :admin_administrators_path, :title => I18n.t("controllers.admin.administrators.breadcrumb_title")

    # show all of the admins for the system

    def index
      # set title
      @admins = Admin.all
      set_title(I18n.t("generic.users"))
    end


    # create a new admin object

    def new
      # add breadcrumb and set title
      add_breadcrumb I18n.t("generic.add_new_user")
      set_title(I18n.t("generic.add_new_user"))

      @admin = Admin.new
      @action = 'create'
    end


    # actually create the new admin with the given param data

    def create
      @admin = Admin.new(administrator_params)
      respond_to do |format|

        if @admin.save

          profile_images(params, @admin)
          Emailer.profile(@admin).deliver

          format.html { redirect_to admin_administrators_path, notice: I18n.t("controllers.admin.administrators.create.flash.success") }

        else
          format.html {
            # add breadcrumb and set title
            add_breadcrumb I18n.t("generic.add_new_user")
            @action = 'create'
            flash[:error] = I18n.t('generic.validation.no_passed')

            render action: "new"
          }
        end

      end
    end


    # get and disply certain admin

    def edit
      @admin = current_admin.id == params[:id].to_i ? @current_admin : Admin.find(params[:id])

      # add breadcrumb and set title
      set_title(I18n.t("controllers.admin.administrators.edit.title", username: @admin.username))
      add_breadcrumb I18n.t("controllers.admin.administrators.edit.breadcrumb")

      # action for the form as both edit/new are using the same form.
      @action = 'update'

      # only allowed to edit the super user if you are the super user.
      if @admin.overlord == 'Y' && @admin.id != session[:admin_id]

        respond_to do |format|

          flash[:error] = I18n.t("controllers.admin.administrators.edit.flash.error")
          format.html { redirect_to admin_administrators_path }

        end

      end
    end

    def show
      redirect_to edit_admin_administrator_path(params[:id])
    end


    # update the admins object

    def update

      @admin = Admin.find(params[:id])

      @admin.deal_with_cover params


      respond_to do |format|

        admin_passed = 
          if params[:admin][:password].blank?
            @admin.update_without_password(administrator_params)
          else
            @admin.update_attributes(administrator_params)
          end

        if admin_passed
          clear_cache
          profile_images(params, @admin)
          format.html { redirect_to edit_admin_administrator_path(@admin), notice: I18n.t("controllers.admin.administrators.update.flash.success") }
        else
          @action = 'update'
          format.html {
            # add breadcrumb and set title
            add_breadcrumb I18n.t("controllers.admin.administrators.edit.breadcrumb")
            flash[:error] = I18n.t('generic.validation.no_passed')
            render action: "edit"
          }
        end

      end

    end


    # Delete the admin, one thing to remember is you are not allowed to destory the overlord.
    # You are only allowed to destroy yourself unless you are the overlord.

    def destroy
      @admin = Admin.find(params[:id])
      @admin.destroy if @admin.overlord == 'N'

      respond_to do |format|
        format.html { redirect_to admin_administrators_path, notice: I18n.t("controllers.admin.administrators.destroy.flash.success") }
      end
    end


    private

    # Strong parameters

    def administrator_params
      params.require(:admin).permit(:email, :password, :first_name, :last_name, :username, :access_level, :password_confirmation, :description)
    end

  end

end