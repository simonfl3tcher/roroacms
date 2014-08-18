require 'spec_helper'

RSpec.describe Roroacms::Admin::TrashController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:record) { FactoryGirl.create(:post, disabled: "Y") }
  before { sign_in(admin) }

  before(:each) do
    record = FactoryGirl.create(:post, disabled: "Y")
  end

  describe "GET #index" do

    before(:each) do
      get :index, { use_route: :roroacms }
    end

    it "should populate an array of pages" do
      expect(assigns(:records)).to_not be_nil
      expect(assigns(:pages)).to_not be_nil
    end

    it "should render the :index template" do
      expect(response).to render_template :index
    end

  end

  describe "DELETE #destroy" do

    it "should delete the post" do
      expect{ delete :destroy, { use_route: :roroacms, id: record } }.to change(Roroacms::Post,:count).by(-1)
    end

    it "should redirect to trash#index" do
      delete :destroy, { use_route: :roroacms, id: record }
      expect(response).to redirect_to "/admin/trash"
    end

  end

  describe "POST #deal_with_form" do

    let!(:array){ [record.id, FactoryGirl.create(:post).id] }

    it "should reinstate the given posts" do
      post :deal_with_form, { use_route: :roroacms, to_do: "reinstate", pages: array }
      record.reload
      expect(record.disabled).to eq('N')
      expect(response).to redirect_to "/admin/trash"
    end

    it "should delete the given posts" do
      post :deal_with_form, { use_route: :roroacms, to_do: "destroy", pages: array }
      expect(Roroacms::Post.where(:id => record.id)).to_not exist
      expect(response).to redirect_to "/admin/trash"
    end

  end
  
end
