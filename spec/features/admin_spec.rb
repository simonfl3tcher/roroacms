require 'spec_helper'

describe "Admin" do

	describe "GET /admin" do

		it "Should redirect to login page" do
			visit admin_path
			current_path.should == admin_login_path
		end
	end

	describe "GET /admin/login" do 

		it "should login" do 
			visit admin_path
			current_path.should == admin_login_path

			fill_in "username", :with => 'admin'
			fill_in "password", :with => '123123'

			click_button "Sign In"
			current_path.should == admin_path
		end

	end

end