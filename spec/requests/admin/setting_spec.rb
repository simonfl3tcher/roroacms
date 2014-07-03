require 'rails_helper'

RSpec.describe "Admin::Settings", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

  	describe "GET /admin/settings" do

  		it "should display settings" do
	  		visit admin_settings_path
	  		expect(page).to have_content('Settings')
	  	end

	  	context "should have different options for different settings" do 

	  		before(:each) do 
	  			visit admin_settings_path
	  		end

	  		it "has general settings" do 
	  			expect(page).to have_content('General')
	  		end

	  		it "has email settings" do
	  			expect(page).to have_content('Email Configuration')
	  		end

	  		it "has comments" do 
	  			expect(page).to have_content('Comments')
	  		end

	  		it "has search engine optimisation" do 
	  			expect(page).to have_content('Search Engine Optimisation')
	  		end

	  		it "has user groups" do 
	  			expect(page).to have_content('User Groups')
	  		end

	  	end

	  	it "updates the settings" do 
	  		visit admin_settings_path
	  		fill_in "articles_slug", :with => 'testing'
	  		find('button[type=submit]').click()
	  		expect(current_path).to eq(admin_settings_path)
	  		expect(page).to have_content('Success')
	  	end

	  	context "does not update the settings" do 

	  		before(:each) do 
	  			visit admin_settings_path
	  		end

	  		it "should not update if article slug is left blank" do 
		  		fill_in "articles_slug", :with => ''
		  		find('button[type=submit]').click()
		  		expect(current_path).to eq(admin_settings_path)
		  		expect(page).to_not have_content('Success')
		  		expect(page).to have_selector('.help-block.error')
	  		end

	  		it "should not update if category_slug is left blank" do
	  			fill_in "category_slug", :with => ''
		  		find('button[type=submit]').click()
		  		expect(current_path).to eq(admin_settings_path)
		  		expect(page).to_not have_content('Success')
		  		expect(page).to have_selector('.help-block.error')
	  		end

	  		it "should not update if tag_slug is left blank" do
	  			fill_in "tag_slug", :with => ''
		  		find('button[type=submit]').click()
		  		expect(current_path).to eq(admin_settings_path)
		  		expect(page).to_not have_content('Success')
		  		expect(page).to have_selector('.help-block.error')
	  		end

	  		it "should not update if smtp_username is left blank" do
	  			fill_in "smtp_username", :with => ''
		  		find('button[type=submit]').click()
		  		expect(current_path).to eq(admin_settings_path)
		  		expect(page).to_not have_content('Success')
		  		expect(page).to have_selector('.help-block.error')
	  		end

	  		it "should not update if smtp_password is left blank" do
	  			fill_in "smtp_password", :with => ''
		  		find('button[type=submit]').click()
		  		expect(current_path).to eq(admin_settings_path)
		  		expect(page).to_not have_content('Success')
		  		expect(page).to have_selector('.help-block.error')
	  		end

	  	end


  	end

end