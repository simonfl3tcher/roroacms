require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

  let!(:record) { FactoryGirl.create(:post) }

  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "POST #create" do

    it "should create the comment" do
      expect{post :create, {comment: FactoryGirl.attributes_for(:comment, post_id: record.id)}}.to change(Comment, :count).by(1)
    end

    it "should redirect back to the referring page" do
      post :create, {comment: FactoryGirl.attributes_for(:comment, post_id: record.id)}
      expect(response).to redirect_to "where_i_came_from#commentsArea"
    end

  end

end
