class ApplicationController < ActionController::Base
  
  protect_from_forgery

  require 'ext/string'

  private 
  
  def render_404
    render :action => 'error_404', :status => 404
  end

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def gloalize content
      @content = content
  end

  helper ViewHelper 
  helper SeoHelper 
  helper GoogleAnalyticsHelper 

  def current_admin
  	@current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def current_admin_access

    @current_admin = Admin.find(session[:admin_id]) if session[:admin_id]

    if !@current_admin.nil?

      return @current_admin.access_level

    else

      return false;

    end

  end

  def authorize_admin
  	redirect_to admin_login_path, error: "Not Authorized" if current_admin.nil?
  end

  def authorize_admin_access

    if current_admin_access == 'editor'

      flash[:error] = "Not authorized"

      redirect_to admin_path

    end

  end

  def restricted_access_check
    # Make function to restrict access via access level on the admin remove - administrators, trash, settings(maybe)
  end
end
