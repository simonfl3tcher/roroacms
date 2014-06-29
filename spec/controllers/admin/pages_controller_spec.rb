require 'rails_helper'

RSpec.describe Admin::PagesController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	before(:each) do 
		@post = FactoryGirl.create(:post)
	end 

	describe "GET #index" do 
		
		it "populates an array of articles" do 
			get :index
	    	expect(assigns(:pages)).to_not be_nil
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


	describe "POST #create" do

		context "with valid attributes" do 

			it "creates new admin" do 
				expect { post :create, {post: FactoryGirl.attributes_for(:post) } }.to change(Post,:count).by(1)
			end

			it "redirects to administrators#index" do 
				post :create, {post: FactoryGirl.attributes_for(:post)}
				expect(response).to redirect_to admin_pages_path
			end

		end

		context "with invalid attributes" do 

			it "does not save the contact" do 
				expect { post :create, { post: FactoryGirl.attributes_for(:invalid_post) } }.to_not change(Post,:count)
			end

			it "re-renders the new method" do 
				post :create, { post: FactoryGirl.attributes_for(:invalid_post) }
				expect(response).to render_template :new
			end

		end

	end

	describe "PUT #update" do 
		
		before(:each) do 
			@post = FactoryGirl.create(:post, post_title: "Testing Rspec post")
		end

		context "valid attributes" do

			it "located the requested record" do 
				put :update, id: @post
				expect(assigns(:record)).to eq(@post)
			end 

			it "changes @admin's attributes" do 
				put :update, { post: FactoryGirl.attributes_for(:post, post_title: "123123"), id: @post }
				@post.reload
				expect(@post.post_title).to eq('123123')
			end

			it "redirects to the updated post" do 
				put :update, { post: FactoryGirl.attributes_for(:post, post_title: "123123"), id: @post }
				expect(response).to redirect_to edit_admin_page_path(@post)
			end

		end

		context "invalid attributes" do 

			it "located the requested record" do 
				put :update, id: @post
				expect(assigns(:record)).to eq(@post)
			end 

			it "does not change @post's attributes" do 
				put :update, { post: FactoryGirl.attributes_for(:invalid_post, post_slug: '123123'), id: @post }
				@post.reload
				expect(@post.post_slug).to_not eq("123123")
			end

			it "re-renders the edit template" do 
				put :update, { post: FactoryGirl.attributes_for(:invalid_post), id: @post }
				expect(response).to render_template :edit
			end

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
			expect(response).to redirect_to admin_pages_path
		end

	end

	describe "POST #bulk_update" do 

		before(:each) do 
			@array = [@post.id, FactoryGirl.create(:post).id]
		end
		
		it "marks the given pages as published" do
			post :bulk_update, { to_do: "publish", pages: @array }
			@post.reload
			expect(@post.post_status).to eq('Published')
			expect(response).to redirect_to admin_pages_path
		end

		it "marks the given pages as drafts" do 
			@post.post_status = 'published'
			post :bulk_update, { to_do: "draft", pages: @array }
			@post.reload
			expect(@post.post_status).to eq('Draft')
			expect(response).to redirect_to admin_pages_path
		end	


		it "moves the given pages into trash" do
			post :bulk_update, { to_do: "move_to_trash", pages: @array }
			@post.reload
			expect(@post.disabled).to eq('Y')
			expect(response).to redirect_to admin_pages_path
		end

	end


end