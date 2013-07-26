require 'spec_helper'

describe "Administators" do

	before(:all) do 
		login_admin
	end

	describe "GET /admin/administators" do

		it "Should show a list of admins" do
			visit admin_administators_path
			page.should have_content "Administrators"
		end

		it "Creates a new administator"

	end

	describe "PUT /admin/administrators" do 

		it "should edit a task" do
			visit admin_administators_path
			click_link "Edit"


			current_path.should == edit_task_path(@task)

			save_and_open_page

			find_field('Task').value.should == 'go to bed'

			fill_in 'Task', :with => 'updated task'
			click_button 'Update Task'

			current_path.should == admin_administators_path

			page.should have_content "Admin was successfully updated."

		end

		it "should fail to update" do 


		end

	end

	describe "DELETE /admin/administrators/:id" do

	   it "deletes a administator" do

	   visit admin_administators_path
	   click_link "Delete"

	   current_path.should == admin_administators_path

	   page.should have_content "Admin was successfully deleted."

	   end

   end

end
