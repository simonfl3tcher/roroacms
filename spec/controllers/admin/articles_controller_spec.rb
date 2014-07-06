require 'rails_helper'

RSpec.describe Admin::ArticlesController, :type => :controller do

	let!(:admin) { FactoryGirl.create(:admin) }
	let!(:new_post) { FactoryGirl.create(:post) }
	before { sign_in(admin) }

	describe "GET #index" do 

		before(:each) do 
			get :index
		end
		
		it "populates an array of articles" do 
	    	expect(assigns(:posts)).to_not be_nil
		end
		
		it "renders the :index template" do 
			expect(response).to render_template :index
		end
	
	end

	describe "GET #new" do

		before(:each) do 
			get :new
		end

		it "should create a new admin object" do 
			expect(assigns(:record)).to_not be_nil
		end

		it "renders the :new template" do
			expect(response).to render_template :new
		end

		it "assigns form action to variable" do 
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
				expect(response).to redirect_to admin_articles_path
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

		context "valid attributes" do

			it "located the requested record" do 
				put :update, id: new_post
				expect(assigns(:record)).to eq(new_post)
			end 

			it "changes @admin's attributes" do 
				put :update, { post: FactoryGirl.attributes_for(:post, post_title: "123123"), id: new_post }
				new_post.reload
				expect(new_post.post_title).to eq('123123')
			end

			it "redirects to the updated post" do 
				put :update, { post: FactoryGirl.attributes_for(:post, post_title: "123123"), id: new_post }
				expect(response).to redirect_to edit_admin_article_path(new_post)
			end

		end

		context "invalid attributes" do 

			it "located the requested record" do 
				put :update, id: new_post
				expect(assigns(:record)).to eq(new_post)
			end 

			it "does not change new_post's attributes" do 
				put :update, { post: FactoryGirl.attributes_for(:invalid_post, post_slug: '123123'), id: new_post }
				new_post.reload
				expect(new_post.post_slug).to_not eq("123123")
			end

			it "re-renders the edit template" do 
				put :update, { post: FactoryGirl.attributes_for(:invalid_post), id: new_post }
				expect(response).to render_template :edit
			end

		end

	end

	describe "DELETE #destroy" do 

		it "deletes the contact" do 
			delete :destroy, id: new_post
			expect(Post.find(new_post).disabled).to eq('Y')
		end

		it "redirect to artciles#index" do 
			delete :destroy, id: new_post
			expect(response).to redirect_to admin_articles_path
		end

	end


end