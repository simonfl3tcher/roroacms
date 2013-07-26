require 'spec_helper'

describe "Admin" do

	describe "GET /admin" do

		it "Should redirect to login page" do
			visit admin_path
			response.should redirect_to(admin_login_path)
		end
	end

	describe "GET /admin/login" do 

		it "should login" do 
			user = FactoryGirl.create(:access_admin)
			visit login_path
			fill_in "username", :with => user.username
			fill_in "password", :with => user.password
			click_button "Sign In"

			response.should redirect_to(admin_path)
		end

	end

end
