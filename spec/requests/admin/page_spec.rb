require 'rails_helper'

# very similar to the article_request_spec.rb as they are virtually the same!

RSpec.describe "Admin::Pages", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }
	let!(:record) { FactoryGirl.create(:post, post_type: 'page') }

  	describe "GET /admin/pages" do

  		it "should show pages" do 
  			visit admin_pages_path
  			expect(page).to have_content('Pages')
  			expect(page).to have_content(record.post_title)
  		end

  		it "should have a button to allow user to create new article" do 
  			visit admin_pages_path
  			find('#add-new-page').click
  			expect(current_path).to eq(new_admin_page_path)
  			expect(page).to have_content('Create New Page')
  		end

  	end

  	describe "GET /admin/pages/new" do
  		let(:article) { FactoryGirl.build(:post, post_type: 'page') }

  		it "should create new page" do 
	  		visit new_admin_page_path
	  		fill_in 'post_post_title', :with => article.post_title
	  		fill_in 'post_post_slug', :with => article.post_slug
	  		click_button 'Save'
	  		expect(current_path).to eq(admin_pages_path)
	  		expect(page).to have_content('success')
	  	end

	  	it "should not allow title to be blank" do 
	  		visit new_admin_page_path
	  		click_button 'Save'
	  		expect(current_path).to eq(admin_pages_path)
	  		expect(page).to have_selector('.help-block.error')
	  		expect(page).to have_content('Title is required')
	  		expect(page).to have_content('Url is required')
	  	end

	  	it "should not have the option to add categories" do 
	  		visit new_admin_page_path
	  		expect(page).to_not have_content('Tags & Categories')
	  	end

	  	it "should not have any revisions" do 
	  		visit new_admin_page_path
	  		expect(page).to have_content('There are no revisions')
	  	end

  	end

  	describe "PUT /admin/page/#id" do 

  		it "should update the page" do
  			visit edit_admin_page_path(record.id)
  			fill_in 'post_post_content', :with => Faker::Lorem.paragraph(5) 
  			click_button 'Save'
  			expect(current_path).to eq(edit_admin_page_path(record.id))
  			expect(page).to have_content('Success')
  		end

  		it "should not allow you to update the page with no title" do 
  			visit edit_admin_page_path(record.id)
  			fill_in 'post_post_title', :with => ''
  			click_button 'Save'
  			expect(current_path).to eq(admin_page_path(record.id))
  			expect(page).to have_selector('.help-block.error')
	  		expect(page).to have_content('Title is required')
  		end

  	end

end