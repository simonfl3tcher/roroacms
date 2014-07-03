require 'rails_helper'

RSpec.describe "Admin::Terms", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

  	describe "GET /admin/article/categories" do

  		let!(:category) { FactoryGirl.create(:term) }

  		it "shoud show categories" do 
	  		visit  admin_article_categories_path
	  		expect(page).to have_content('Categories')
	  		expect(page).to have_content(category.name)
  		end

  		it "should have a form to create a tag" do 
	  		visit admin_article_tags_path
	  		expect(page).to have_css('form#new_term')
	  	end

  	end

  	describe "GET /admin/article/tags" do

  		let!(:tag) { FactoryGirl.create(:term_tag) }
		let!(:term){ FactoryGirl.build(:term_tag) }

  		it "shoud show tags" do 
	  		visit  admin_article_tags_path
	  		expect(page).to have_content('Tags')

	  		expect(page).to have_content(tag.name)
	  	end

	  	it "should have a form to create a tag" do 
	  		visit admin_article_tags_path
	  		expect(page).to have_css('form#new_term')
	  	end

	  	context "Creating a tag" do 

	  		before(:each) do 
		  		visit admin_article_tags_path
	  		end

		  	it "should create a new tag" do 
		  		fill_in "term_name", :with => term.name
		  		fill_in "term_slug", :with => term.slug
		  		click_button 'Save'

		  		expect(current_path).to eq(admin_article_tags_path)
		  		expect(page).to have_content('Success')
		  	end

		  	it "should not allow you to create a tag with no name" do 
		  		fill_in "term_slug", :with => term.slug
		  		click_button 'Save'
		  		expect(current_path).to eq(admin_article_tags_path)
		  		expect(page).to have_content('Error')
		  	end

		  	it "should allow you to create a tag with no slug" do 
		  		fill_in "term_name", :with => term.name
		  		fill_in "term_slug", :with => ''
		  		click_button 'Save'
		  		expect(current_path).to eq(admin_article_tags_path)
		  		expect(page).to have_content('Success')
		  	end

	  	end

	  	context "Editing a tag" do 

	  		it "should allow you to edit the tag" do 
	  			visit admin_article_tags_path
	  			find(:xpath, "//a[@href='/admin/terms/145/edit']").click
	  		end

	  		it "should user to update the name" do 
	  			visit edit_admin_term_path(tag.id)
	  			expect(page).to have_content('Article Tag')

	  			fill_in "term_name", :with => term.name
	  			click_button 'Save'

	  			expect(current_path).to eq(edit_admin_term_path(tag.id))
	  			expect(page).to have_content('Success')
	  		end

	  		it "should not allow user to update a tag with no name" do 
	  			visit edit_admin_term_path(tag.id)
	  			fill_in "term_name", :with => ''
	  			click_button 'Save'

	  			expect(current_path).to eq(admin_term_path(tag.id))
	  			expect(page).to have_selector('.help-block.error')
	  		end

	  	end

  	end


end