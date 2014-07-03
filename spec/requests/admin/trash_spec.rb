require 'rails_helper'

RSpec.describe "Admin::Trash", :type => :request do

	let!(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

	describe "GET /admin/trash" do

		it "should display trash" do
			visit admin_trash_path
			expect(page).to have_content "Trash"
		end

		it "should show no records message" do 
			visit admin_trash_path
			expect(page).to have_content('The trash can is currently empty')
		end

		context "with posts or pages in the trash can" do 

			let!(:post_post) { FactoryGirl.create(:post, disabled: 'Y', post_type: 'post') }
			let!(:post_page) { FactoryGirl.create(:post, disabled: 'Y', post_type: 'page') }

			it "should have have post on view" do 
				visit admin_trash_path
				expect(page).to have_content post_post.post_title
			end

			it "should have page on view" do 
				visit admin_trash_path
				expect(page).to have_content post_page.post_title
			end

			it "should display the total count of pages" do 
				visit admin_trash_path
				expect(page).to have_content("Total Count #{Post.where(:disabled => 'Y', :post_type => 'page').count}")
			end

			it "should display the total count of posts" do 
				visit admin_trash_path
				expect(page).to have_content("Total Count #{Post.where(:disabled => 'Y', :post_type => 'post').count}")
			end

			# tests what happens if there is no posts but there are pages


			# put these at the bottom

			it "should delete all post records" do 
				visit admin_trash_path
				find(:css, "#posts").click_link("Delete all")
				expect(current_path).to eq(admin_trash_path)
				expect(page).to have_content('All posts were removed from the trash can')
				expect(page).to have_content post_page.post_title
			end

			it "should delete all page records" do 
				visit admin_trash_path
				find(:css, "#pages").click_link("Delete all")
				expect(current_path).to eq(admin_trash_path)
				expect(page).to have_content('All pages were removed from the trash can')
			end

		end

	end

end