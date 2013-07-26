require 'spec_helper'

describe "Theme" do

	before(:all) do 
		login_admin
	end

	describe "GET /admin/theme" do

		it "Should show a list of themes" do
			visit admin_theme_path
			page.should have_content "Themes"
		end

		it "changes the theme" do 
			visit admin_theme_path
			find(:css, "#cityID[value='62']").set(true)

			click_button 'Update'

			current_path.should == admin_themes_path

			page.should have_content "Theme used was updated."
		end

		it "changes deletes the theme" do 
			visit admin_theme_path
			click_button 'icon-trash'

			current_path.should == admin_themes_path

			page.should have_content "Theme used was deleted"
		end

	end

end
