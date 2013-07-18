require "spec_helper"

describe Admin::PostsController do 

	describe "GET #index" do
		it "populates an array of posts" do
			get :index
      		assigns(:post).should_not be_nil
		end

		it "renders the :index view" do
			get :index
			response.should_not render_template :index
		end
	end

	describe "GET #new" do

		it "assigns a new post to @post" do
			get :new
      		assigns(:post).should be_nil
		end

		it "renders the :new template" do
			get :new
			response.should_not render_template :new
		end

	end

	describe "POST post" do

		context "with valid attributes" do

			it "creates a new post" do 

				expect {
					post :create, post: FactoryGirl.create(:post)
				}.to change(Post, :count).by(1)

			end

			it "redirects to the new contact" do
				post :create, post: FactoryGirl.create(:post)
				response.should redirect_to admin_login_path
			end

		end

		context "with invalid attributes" do

			it "does not save the post" do
				expect {
					post :create, post: FactoryGirl.build(:post, post_title: nil)
				}.not_to change(Post, :count)
			end

			it "re-renders the :new method" do 
				post :create, post: FactoryGirl.build(:post, post_title: nil)
				response.should render_template :create
			end

		end

	end

	describe "PUT update" do

		before :each do 
			@post = Post.new
		end

		context "valid attributes" do
			
			it "located the request @contact" do 
				put :edit, id: @post, post: FactoryGirl.create(:post)
				assigns(:post).should eq([@post])
			end

			it "changes @post's attr" do 

				put :update, id: @post, post: FactoryGirl.attributes_for(:post, post_title: 'something new')

				@post.reload
				@post.post_title.should eq("something new")

			end
		end

	end

	describe "delete destroy" do

		before :each do 
			@post = FactoryGirl.create(:post)
		end

		it "deletes the contact" do
			expect {
				Post.destroy(@post)
				}.to change(Post, :count).by(-1)
		end

		it "redirects to post page" do
			delete :destroy, id: @post
			response.should redirect_to admin_login_path
		end

	end
end