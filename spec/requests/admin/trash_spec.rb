require 'rails_helper'

RSpec.describe "Admin::Trash", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

	describe "GET /admin/administrators" do

		context "without posts or pages in the trash can" do 
			expect(page).to have_content('The trash can is currently empty')
		end

		context "with posts or pages in the trash can" do 

			before(:each) do 
				let!(:post) { FactoryGirl.create(:post, disabled: 'Y', post_type: 'post') }
				let!(:page) { FactoryGirl.create(:post, disabled: 'Y', post_type: 'page') }
				visit admin_trash_path
			end

			it "should display trash" do 
				expect(page).to have_content "Trash"
			end

			it "should have have post on view" do 
				expect(page).to have_content post.title
			end

			it "should have page on view" do 
				expect(page).to have_content page.title
			end

			it "should delete all records" do 
				# this html find function needs cleaning up
				find('page #delete_all').click
				expect(current_path).to eq(admin_trash_path)
				expect(page).to have_content('')
			end

			it "should delete certian records" do 
				
			end

			it "should reinstate certain records" do 
				first('reinstate').click
				expect(current_path).to eq(admin_trash_path)
				expect(page).to have_content('These records was successfully reinstated')
			end

		end

	end

end