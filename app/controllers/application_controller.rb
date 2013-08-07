class ApplicationController < ActionController::Base
   
  protect_from_forgery
  helper ShortcodeHelper 
  helper ViewHelper 
  helper MenuHelper
  helper SeoHelper  
  helper ThemeHelper 
  helper CommentsHelper

  before_filter :installation

  require 'ext/string'
 
  private

  def render_404
    render :template => "theme/#{current_theme}/error_404", :layout => true, :status => :not_found
  end

  def current_theme 

    @theme_folder = Setting.find_by_setting_name('theme_folder')[:setting]

  end 

  helper_method :current_theme

  def installation 
    # path = request.env['PATH_INFO'].include? '/installation'request.env['PATH_INFO'].include? '/installation'.include? '/installation'
    # redirect_to installation_path, error: "Not Authorized" if Dir.exists?("app/controllers/installation/") && path == false
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def gloalize content
      @content = content
  end

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

end
