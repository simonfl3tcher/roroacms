require 'rails_helper'

RSpec.describe Admin::RevisionsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	before(:each) do 
		@revision = Post.where(:post_type => 'autosave').first
	end

	describe "PUT #edit" do 

		it "should get the revision object" do 
			get :edit, id: @revision
			expect(assigns(:post)).to_not be_nil
			expect(assigns(:revision)).to_not be_nil
		end

		it "renders the :edit template" do
			get :edit, id: @revision
			expect(response).to render_template :edit
		end

	end

	describe "GET #restore" do
			
		it "restores the parent post to the given revision" do 
			get :restore, id: @revision.id

			parent = Post.find(@revision.parent_id)

			if parent.post_type == 'page'
				url = "/admin/pages/#{parent.id}/edit"
			elsif parent.post_type == 'post'
				url = "/admin/articles/#{parent.id}/edit"
			end

			expect(response).to redirect_to url
		end

	end

end