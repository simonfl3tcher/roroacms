require 'rails_helper'

RSpec.describe Admin::RevisionsController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:revision){ Post.where(:post_type => 'autosave').first }
  before { sign_in(admin) }

  describe "PUT #edit" do

    before(:each) do
      get :edit, id: revision
    end

    it "should get the revision object" do
      expect(assigns(:post)).to_not be_nil
      expect(assigns(:revision)).to_not be_nil
    end

    it "should render the :edit template" do
      expect(response).to render_template :edit
    end

  end

  describe "GET #restore" do

    it "should restore the parent post to the given revision" do
      get :restore, id: revision.id

      parent = Post.find(revision.parent_id)

      if parent.post_type == 'page'
        url = "/admin/pages/#{parent.id}/edit"
      elsif parent.post_type == 'post'
        url = "/admin/articles/#{parent.id}/edit"
      end

      expect(response).to redirect_to url
    end

  end

end
