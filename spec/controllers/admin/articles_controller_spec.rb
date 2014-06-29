require 'rails_helper'

RSpec.describe Admin::ArticlesController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do 
		
		it "populates an array of contacts" do 
			get :index
	    	expect(assigns(:posts)).to_not be_nil
		end
		
		it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end
	
	end

	describe "GET #new" do

		it "should create a new admin object" do 
			get :new
			expect(assigns(:record)).to_not be_nil
		end

		it "renders the :new template" do
			get :new
			expect(response).to render_template :new
		end

		it "assigns form action to variable" do 
			get :new
			expect(assigns(:action)).to eq('create')
		end

	end

	describe "DELETE #destroy" do 
		
		before(:each) do
			@post = FactoryGirl.create(:post)
		end

		it "deletes the contact" do 
			delete :destroy, id: @post
			expect(Post.find(@post).disabled).to eq('Y')
		end

		it "redirect to artciles#index" do 
			delete :destroy, id: @post
			expect(response).to redirect_to admin_articles_path
		end

	end


end