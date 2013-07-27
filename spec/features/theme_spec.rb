require 'spec_helper'

describe "Theme" do

	before(:each) do 

		visit admin_path 
		current_path.should == admin_login_path
	  	fill_in 'username', with: 'admin'
	  	fill_in 'password', with: '123123' 
	  	click_button 'Sign In' 

	  	current_path.should == admin_path
	  	
	end

	describe "GET /admin/theme" do

		it "Should show a list of themes" do
			visit admin_themes_path
			page.should have_content "Themes"
		end


		it "changes deletes the theme" do 
			visit admin_themes_path
			page.all('table a')[0].click

			current_path.should == admin_themes_path

			page.should have_content "Theme used was deleted"
		end

		it "changes the theme" do 
			visit admin_themes_path
			find(:css, "#theme_roroa2").set(true)

			click_button 'Update'

			current_path.should == admin_themes_path

			page.should have_content "Theme used was updated"
		end
	end

end
