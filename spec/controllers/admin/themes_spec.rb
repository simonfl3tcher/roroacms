require "spec_helper"

describe Admin::ThemesController do 

	before(:all) do 
		login_admin
	end

	describe "GET #index" do
		it "populates an array of posts" do
			get :index
      		assigns(:theme).should_not be_nil
		end

		it "renders the :index view" do
			get :index
			response.should render_template :index
		end
	end

	describe "DELETE destroy" do

		it "redirects to themes page" do
			response.should redirect_to admin_theme_path
		end

	end


end