require 'rails_helper'

RSpec.describe Admin::TrashController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }
	
	before(:each) do
		@post = FactoryGirl.create(:post, disabled: "Y")
	end

	describe "GET #index" do

		it "populates an array of pages" do 
			get :index
	    	expect(assigns(:records)).to_not be_nil
	    	expect(assigns(:pages)).to_not be_nil
	    end

	    it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end

	end

	describe "DELETE #destroy" do 


		it "deletes the post" do 
			expect{delete :destroy, id: @post}.to change(Post,:count).by(-1)
		end

		it "redirect to trash#index" do 
			delete :destroy, id: @post
			expect(response).to redirect_to admin_trash_path
		end

	end

	describe "POST #deal_with_form" do 

		before(:each) do 
			@array = [@post.id, FactoryGirl.create(:post).id]
		end
		
		it "reinstates the given posts" do
			post :deal_with_form, { to_do: "reinstate", pages: @array }
			@post.reload
			expect(@post.disabled).to eq('N')
			expect(response).to redirect_to admin_trash_path
		end

		it "deletes the given posts" do
			post :deal_with_form, { to_do: "destroy", pages: @array }
			@post.reload
			expect(Post.where(:id => @post.id)).to_not exist
			expect(response).to redirect_to admin_trash_path
		end

	end


end