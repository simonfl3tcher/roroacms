require 'rails_helper'

RSpec.describe "Admin::Revisions", :type => :request do

	let(:admin) { FactoryGirl.create(:admin) }
  	before { sign_in(admin) }

  	before(:each) do 
  		@revision = Post.where(:post_type => 'autosave').first
  		@post = Post.find(@revision.parent_id)
  	end

  	describe "GET /admin/revisions/#id/edit" do

  		it "should show list of revisions" do 
	  		visit edit_admin_revision_path(@revision.id)
	  		expect(page).to have_content('Revision for')
	  		expect(page).to have_content('Keycode')
	  		expect(page).to have_content('Revision Saved At')
  		end

  		it "should have option to restore" do 
  			visit edit_admin_revision_path(@revision.id)
  			click_link "Restore"

  			if @post.post_type == 'page'
				url = "/admin/pages/#{@post.id}/edit"
			elsif @post.post_type == 'post'
				url = "/admin/articles/#{@post.id}/edit"
			end

  			expect(current_path).to eq(url)
  		end

  	end
  	
end