require 'spec_helper'

RSpec.describe Roroacms::Admin::CommentsController, :type => :controller do

  routes { Roroacms::Engine.routes }

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:comment) { FactoryGirl.create(:comment) }
  before { sign_in(admin) }

  describe "GET #index" do

    it "should render the :index template" do
      get :index, { use_route: :roroacms }
      expect(response).to render_template :index
    end

  end

  describe "PUT #edit" do

    before(:each) do
      get :edit, { use_route: :roroacms, id: comment }
    end

    it "should create the comment object" do
      expect(assigns(:comment)).to_not be_nil
    end

    it "should render the :edit template" do
      expect(response).to render_template :edit
    end

  end

  describe "PUT #update" do

    it "should locate the requested record" do
      get :update, { use_route: :roroacms, id: comment, comment: FactoryGirl.attributes_for(:comment) }
      expect(assigns(:comment)).to eq(comment)
    end

    context "valid attributes" do

      before(:each) do
        put :update, { use_route: :roroacms, comment: FactoryGirl.attributes_for(:comment, author: 'Testing') , id: comment }
      end

      it "should change comment's attributes" do
        comment.reload
        expect(comment.author).to eq('Testing')
      end

      it "should redirect to the updated comment" do
        expect(response).to redirect_to "/admin/comments/#{comment.id}/edit"
      end

    end

    context "invalid attributes" do

      before(:each) do
        put :update, { use_route: :roroacms, comment: FactoryGirl.attributes_for(:invalid_comment, website: 'Testing') , id: comment }
      end

      it "should not change comment's attributes" do
        comment.reload
        expect(comment.website).to_not eq('Testing')
      end

      it "should re-render the edit template" do
        expect(response).to render_template :edit
      end

    end

  end

  describe "DELETE #destroy" do

    it "should delete the comment" do
      expect{ delete :destroy, { use_route: :roroacms, id: comment } }.to change(Roroacms::Comment, :count).by(-1)
    end

  end

  describe "POST #bulk_update" do

    let!(:array) { [comment.id, FactoryGirl.create(:comment).id] }

    it "should mark the given comments as unapproved" do
      post :bulk_update, { use_route: :roroacms, to_do: "unapprove", comments: array }
      comment.reload
      expect(comment.comment_approved).to eq('N')
      expect(response).to redirect_to "/admin/comments"
    end

    it "should mark the given comments as approved" do
      post :bulk_update, { use_route: :roroacms, to_do: "approve", comments: array }
      comment.reload
      expect(comment.comment_approved).to eq('Y')
      expect(response).to redirect_to "/admin/comments"
    end

    it "should destroy the given comments" do
      post :bulk_update, { use_route: :roroacms, to_do: "destroy", comments: array }
      expect(Roroacms::Comment.where(:id => comment.id)).to_not exist
      expect(response).to redirect_to "/admin/comments"
    end

  end

  describe "GET #mark_as_spam" do

    it "should set the given record to spam" do
      get :mark_as_spam, { use_route: :roroacms, id: comment }
      comment.reload
      expect(comment.is_spam).to eq('S')
    end

  end

end
