require 'rails_helper'

RSpec.describe "Admin::Themes", :type => :request do

	let!(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

  	describe "GET /admin/themes" do

  		it "should display the avalible themes" do 
  			visit admin_themes_path
  			expect(page).to have_content('Themes')
  			expect(page).to have_content('roroa 1')
  		end

  		it "should allow you to update the current theme" do 
  			visit admin_themes_path
  			find('#theme_roroa1').set(true)
  			find('button[type=submit]').click
  			expect(current_path).to eq(admin_themes_path)
  			expect(page).to have_content('Success!')
  		end

  	end

end