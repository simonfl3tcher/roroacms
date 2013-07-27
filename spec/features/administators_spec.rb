require 'spec_helper'

describe "Administators" do

	before(:each) do 

		visit admin_path 
		current_path.should == admin_login_path
	  	fill_in 'username', with: 'admin'
	  	fill_in 'password', with: '123123' 
	  	click_button 'Sign In' 

	  	current_path.should == admin_path
	end

	describe "GET /admin/administators" do

		it "Should show a list of admins" do
			visit admin_administrators_path
			page.should have_content "Administrators"
		end

		it "Creates a new administator" do
			pending()
			user = FactoryGirl.create(:admin)
			visit admin_administrators_path
			page.find('.span6 a').click
			
			current_path.should == new_admin_administrator_path

			fill_in "admin_username", :with => user.username
			fill_in "admin_email", :with => user.email
			fill_in "admin_password", :with => user.password
			fill_in "admin_password_confirmation", :with => user.password
			click_button 'Create Administrator'

			current_path.should == admin_administrators_path

			page.should have_content "Admin was successfully created."
		end

	end

	describe "PUT /admin/administrators" do 

		it "should edit a task" do
			visit admin_administrators_path
			current_path.should == admin_administrators_path
			page.all('.edit')[1].click


			current_path.should == edit_admin_administrator_path(4)

			save_and_open_page

			fill_in 'admin_username', :with => 'admin2'
			click_button 'Update Administrator'

			current_path.should == edit_admin_administrator_path(4)

			page.should have_content "Admin was successfully updated."

		end

		it "should fail to update" do 
			visit admin_administrators_path
			current_path.should == admin_administrators_path
			page.all('.edit')[1].click


			current_path.should == edit_admin_administrator_path(4)

			save_and_open_page

			fill_in 'admin_username', :with => ''
			click_button 'Update Administrator'

			current_path.should == admin_administrator_path(4)

			page.should have_content "Username can't be blank"

		end

	end

	describe "DELETE /admin/administrators/:id" do

	   it "deletes a administator" do

	   visit admin_administrators_path
	   current_path.should == admin_administrators_path
	   page.all('.delete')[1].click

	   current_path.should == admin_administrators_path

	   page.should have_content "Admin was successfully deleted."

	   end

   end

end
