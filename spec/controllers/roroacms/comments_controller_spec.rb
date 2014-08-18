require 'spec_helper'

RSpec.describe Roroacms::CommentsController, :type => :controller do

  let!(:record) { FactoryGirl.create(:post) }

  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end

  describe "POST #create" do

    it "should create the comment" do
      expect{post :create, { use_route: :roroacms, comment: FactoryGirl.attributes_for(:comment, post_id: record.id) } }.to change(Roroacms::Comment, :count).by(1)
    end

    it "should redirect back to the referring page" do
      post :create, { use_route: :roroacms, comment: FactoryGirl.attributes_for(:comment, post_id: record.id) }
      expect(response).to redirect_to "where_i_came_from#commentsArea"
    end

  end

end
