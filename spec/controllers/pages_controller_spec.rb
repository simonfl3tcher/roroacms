require 'rails_helper'

RSpec.describe PagesController, :type => :controller do

	before(:each) do 
		@post = FactoryGirl.create(:post, post_status: 'Published')
		@post_draft = FactoryGirl.create(:post, post_status: 'Draft')
	end

	describe "GET /pages/#id" do 

		it "should show any post" do 
			get :show, id: @post_draft.id
			expect(response.status).to eq(302)
			expect(response).to redirect_to @post_draft.structured_url
		end

	end

	describe "dynamic_page" do 
		
		it "should route to the necessary page" do 
			url = @post.structured_url[1..-1]
			get :dynamic_page, {slug: url}
			expect(response.status).to eq(200)
		end

		it "should render 404" do 
			url = @post_draft.structured_url[1..-1]
			get :dynamic_page, {slug: url}
			expect(response.status).to eq(404)
		end

	end

end