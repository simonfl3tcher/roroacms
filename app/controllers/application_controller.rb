class ApplicationController < ActionController::Base

  before_filter :configure_permitted_parameters, if: :devise_controller?

  
  require 'ext/string'

  protect_from_forgery
  helper ShortcodeHelper 
  helper ViewHelper 
  helper MenuHelper
  helper SeoHelper  
  helper CommentsHelper
  helper GeneralHelper
  include GeneralHelper
  include ViewHelper

  private

  # Override the generic 404 page to use the 404 in the theme directory

  def render_404
    render( :template => "theme/#{current_theme}/error_404", :layout => true, :status => :not_found) if File.exists?("app/views/theme/#{current_theme}/error_404.html.erb")
  end

  # Get the current theme being used by the application

  def current_theme 
    @theme_folder = Setting.get('theme_folder')
  end 

  helper_method :current_theme

  # theme extension 

  def get_theme_ext 
    theme_yaml('view_extension')
  end

  helper_method :get_theme_ext

  # Return the current user data

  def current_user 
    if !session["warden.user.admin.key"].blank?
      Admin.find(session["warden.user.admin.key"][0][0])
    else
      nil
    end
  end
  helper_method :current_user
  
  # globalize allows access to all of the given content from anywhere

  def gloalize content
      @content = content
  end


  # Return the current user logged in as admin data

  def current_admin
  	@current_admin ||= current_user if !current_user.blank?
  end

  # Returns the current access that is granted to the logged in admin. Allowing you to restrict necessary areas to certain types of user
  # currently there are only two user types (admin or editor)

  def current_admin_access
    @current_admin = current_user if !current_user.blank?

    if !@current_admin.nil?
      return @current_admin.access_level
    else
      return false;
    end
  end


  # checks if the admin is logged in before anything else

  def authorize_admin
  	redirect_to admin_login_path, error: "Not Authorized" if current_user.nil?
  end

  # devise settings

  def after_sign_in_path_for(resource)
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
    Admin.set_sessions(session, current_user)
    admin_path
  end

  def after_sign_out_path_for(resource_or_scope)
    Admin.destroy_session session
    admin_login_index_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :first_name, :last_name, :username, :access_level, :password_confirmation, :description)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :first_name, :last_name, :username, :access_level, :password_confirmation, :description)
    end
  end

end
