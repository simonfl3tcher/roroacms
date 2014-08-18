require 'spec_helper'

RSpec.describe Roroacms::Admin::PagesController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:record) { FactoryGirl.create(:post) }
  before { sign_in(admin) }

  describe "GET #index" do

    before(:each) do
      get :index, { use_route: :roroacms }
    end

    it "should populate an array of articles" do
      expect(assigns(:pages)).to_not be_nil
    end

    it "should render the :index template" do
      expect(response).to render_template :index
    end

  end

  describe "GET #new" do

    before(:each) do
      get :new, { use_route: :roroacms }
    end

    it "should create a new admin object" do
      expect(assigns(:record)).to_not be_nil
    end

    it "should render the :new template" do
      expect(response).to render_template :new
    end

    it "should assign form action to variable" do
      expect(assigns(:action)).to eq('create')
    end

  end


  describe "POST #create" do

    context "with valid attributes" do

      it "should create new admin" do
        expect { post :create, { use_route: :roroacms, post: FactoryGirl.attributes_for(:post) } }.to change(Roroacms::Post,:count).by(1)
      end

      it "should redirect to administrators#index" do
        post :create, { use_route: :roroacms, post: FactoryGirl.attributes_for(:post) }
        expect(response).to redirect_to "/admin/pages"
      end

    end

    context "with invalid attributes" do

      it "should not save the contact" do
        expect { post :create, { use_route: :roroacms, post: FactoryGirl.attributes_for(:invalid_post)} }.to_not change(Roroacms::Post,:count)
      end

      it "should re-render the new method" do
        post :create, { use_route: :roroacms, post: FactoryGirl.attributes_for(:invalid_post) }
        expect(response).to render_template :new
      end

    end

  end

  describe "PUT #update" do

    it "should locate the requested record" do
      put :update, { use_route: :roroacms, id: record, post: FactoryGirl.attributes_for(:post) }
      expect(assigns(:record)).to eq(record)
    end

    context "valid attributes" do

      before(:each) do
        put :update, { use_route: :roroacms, post: FactoryGirl.attributes_for(:post, post_title: "123123"), id: record }
      end

      it "should change @admin's attributes" do
        record.reload
        expect(record.post_title).to eq('123123')
      end

      it "should redirect to the updated post" do
        expect(response).to redirect_to "/admin/pages/#{record.id}/edit"
      end

    end

    context "invalid attributes" do

      before(:each) do
        put :update, { use_route: :roroacms, post: FactoryGirl.attributes_for(:invalid_post, post_slug: '123123'), id: record }
      end

      it "should not change record's attributes" do
        record.reload
        expect(record.post_slug).to_not eq("123123")
      end

      it "should re-render the edit template" do
        expect(response).to render_template :edit
      end

    end

  end


  describe "POST #bulk_update" do

    let!(:array) { [record.id, FactoryGirl.create(:post).id] }

    it "should mark the given pages as published" do
      post :bulk_update, { use_route: :roroacms, to_do: "publish", pages: array }
      record.reload
      expect(record.post_status).to eq('Published')
      expect(response).to redirect_to "/admin/pages"
    end

    it "should mark the given pages as drafts" do
      record.post_status = 'published'
      post :bulk_update, { use_route: :roroacms, to_do: "draft", pages: array }
      record.reload
      expect(record.post_status).to eq('Draft')
      expect(response).to redirect_to "/admin/pages"
    end


    it "should move the given pages into trash" do
      post :bulk_update, { use_route: :roroacms, to_do: "move_to_trash", pages: array }
      record.reload
      expect(record.disabled).to eq('Y')
      expect(response).to redirect_to "/admin/pages"
    end

  end

  describe "DELETE #destroy" do

    it "should delete the contact" do
      delete :destroy, { use_route: :roroacms, id: record }
      expect(Roroacms::Post.find(record).disabled).to eq('Y')
    end

    it "should redirect to artciles#index" do
      delete :destroy, { use_route: :roroacms, id: record }
      expect(response).to redirect_to "/admin/pages"
    end

  end
  
end
