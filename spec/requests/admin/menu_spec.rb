require 'rails_helper'

# 90% of this section is controller via javascipt hence the minimal specs

RSpec.describe "Admin::Menus", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
	let(:menu_build) { FactoryGirl.build(:menu) }
	let!(:menu) { FactoryGirl.create(:menu) }
  	before { sign_in(admin) }

  	describe "GET /admin/menus" do

  		it "should display the menus" do 
  			visit admin_menus_path
  			expect(page).to have_content('Menus')
  			expect(page).to have_content('New Menu')
  		end

  		it "should allow you to create a new menu" do 
  			visit admin_menus_path
	  		expect(page).to have_css('form#new_menu')

	  		fill_in 'menu_name', with: menu_build.name
	  		fill_in 'menu_key', with: menu_build.name
	  		click_button 'Add menu group'

	  		expect(page).to have_content('Success')
  		end

  		it "should not allow you to create a new menu without a name or key" do 
  			visit admin_menus_path
	  		fill_in 'menu_name', with: ''
	  		click_button 'Add menu group'
	  		expect(current_path).to eq(admin_menus_path)
	  		expect(page).to have_selector('.help-block.error')
	  		expect(page).to have_content('Name is required')
	  		expect(page).to have_content('Key is required')
  		end

  		it "should have a link to edit menu" do
	  		visit admin_menus_path 
	  		expect(page).to have_content(menu.name)
  			find(:xpath, "//a[@href='/admin/menus/#{menu.id}/edit']").click
  			expect(page).to have_content('Edit')
  		end

  		it "should have link to delete menu" do 
  			visit admin_menus_path 
	  		expect(page).to have_content(menu.name)
	  		expect(page).to have_link("Delete", href: "/admin/menus/#{menu.id}")
  		end

  	end

  	describe "PUT /admin/menus/#id/edit" do 
  		# everything controlled via javascript
  	end

end