require_dependency "roroacms/application_controller"

module Roroacms
  
  class PagesController < ApplicationController


    before_filter :rewrite_theme_helper
    before_filter :check_theme_folder_new


    # everything request that is not the /admin goes through PagesController

    # Include the necessary helpers to load the file, RoutingHelper does the routing of the url to the correct data
    include Roroacms::ViewHelper
    include Roroacms::RoutingHelper
    include Roroacms::GeneralHelper

    # theme helper for the theme
    helper ThemeHelper
    include ThemeHelper

    # a homepage is set in the admin panel, route_index_page will display this page.
    # (params) is also passed in, for the search form which send a GET request to the homepage
    # if the necessary params exist then it will display the search results otherwise it will display the homepage

    def index
      route_index_page params
    end

    # Shows the page via the ID, simlply pass in the ID of the page that you would like to view via params

    def show
      redirect_to show_url(params)
    end


    # if the url has segments the application will run through the dynamic_page method.
    # route_dynamic_page function will take the url and search for the correct data to display

    def dynamic_page
      route_dynamic_page params
    end


    # Check to see if there is a theme installed and if so has it got all the necessary files

    def check_theme_folder_new
      @meta_translation = I18n.t("views.admin.layouts.admin.meta_title_theme_issues")
      @missing = check_necessaries
      render :template => 'roroacms/setup/_theme', :layout => 'roroacms/setup' and return if @missing.is_a?(Hash)
    end

  end

end