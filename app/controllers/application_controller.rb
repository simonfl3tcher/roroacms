class ApplicationController < ActionController::Base
  
  
  protect_from_forgery
  helper ShortcodeHelper 
  helper ViewHelper 
  helper SeoHelper  
  helper ThemeHelper 

  require 'ext/string'


  private

  def render_404
    render :template => 'theme/error_404', :layout => true, :status => :not_found
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


  # def reload_theme_helper

  #   file = File.open("app/views/pages/theme_helper.rb", "rb")
  #   doc = file.read
  #   File.open("app/helpers/theme_helper.rb", 'w') {|f| f.write(doc) }

  # end

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
