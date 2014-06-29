require 'rails_helper'

RSpec.describe Admin::CommentsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	before(:each) do 
		@comment = FactoryGirl.create(:comment)
	end

	describe "GET #index" do 
		
		it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end
	
	end

	describe "PUT #edit" do 

		it "should create the comment object" do 
			get :edit, id: @comment
			expect(assigns(:comment)).to_not be_nil
		end

		it "renders the :edit template" do
			get :edit, id: @comment
			expect(response).to render_template :edit
		end

	end

	describe "PUT #update" do

		it "locates the requested record" do 
			get :update, id: @comment
			expect(assigns(:comment)).to eq(@comment)
		end

		context "valid attributes" do

			it "changes @comment's attributes" do
				put :update, { comment: FactoryGirl.attributes_for(:comment, author: 'Testing') , id: @comment }
				@comment.reload
				expect(@comment.author).to eq('Testing')
			end

			it "redirects to the updated comment" do 
				put :update, { comment: FactoryGirl.attributes_for(:comment, author: 'Testing') , id: @comment }
				expect(response).to redirect_to edit_admin_comment_path(@comment)
			end

		end

		context "invalid attributes" do

			it "does not change @comment's attributes" do 
				put :update, { comment: FactoryGirl.attributes_for(:invalid_comment, website: 'Testing') , id: @comment }
				@comment.reload
				expect(@comment.website).to_not eq('Testing')
			end

			it "re-renders the edit template" do 
				put :update, { comment: FactoryGirl.attributes_for(:invalid_comment) , id: @comment }
				expect(response).to render_template :edit
			end

		end

	end

	describe "DELETE #destroy" do 

		it "deletes the comment" do 
			expect{ delete :destroy, id: @comment }.to change(Comment, :count).by(-1)
		end

	end

	describe "POST #bulk_update" do

		before(:each) do 
			@array = [@comment.id, FactoryGirl.create(:comment).id]
		end

		it "marks the given comments as unapproved" do 
			post :bulk_update, { to_do: "unapprove", comments: @array }
			@comment.reload
			expect(@comment.comment_approved).to eq('N')
			expect(response).to redirect_to admin_comments_path
		end	

		it "marks the given comments as approved" do
			post :bulk_update, { to_do: "approve", comments: @array }
			@comment.reload
			expect(@comment.comment_approved).to eq('Y')
			expect(response).to redirect_to admin_comments_path
		end

		it "destroys the given comments" do
			post :bulk_update, { to_do: "destroy", comments: @array }
			expect(Post.where(:id => @comment.id)).to_not exist
			expect(response).to redirect_to admin_comments_path
		end


	end

	describe "GET #mark_as_spam" do

		it "sets the given record to spam" do 
			get :mark_as_spam, id: @comment
			@comment.reload
			expect(@comment.is_spam).to eq('S')
		end

	end

end