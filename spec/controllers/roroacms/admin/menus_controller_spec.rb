require 'spec_helper'

RSpec.describe Roroacms::Admin::MenusController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:menu) { FactoryGirl.create(:menu) }
  before { sign_in(admin) }

  describe "GET #index" do

    before(:each) do
      get :index, { use_route: :roroacms }
    end

    it "should populate an array of the menu objects" do
      expect(assigns(:all_menus)).to_not be_nil
    end

    it "should create an empty menu object for create form" do
      expect(assigns(:menu)).to_not be_nil
    end

    it "should render the :index template" do
      expect(response).to render_template :index
    end

  end

  describe "PUT #edit" do

    before(:each) do
      get :edit, { use_route: :roroacms, id: menu }
    end

    it "should create the menu object" do
      expect(assigns(:menu)).to_not be_nil
    end

    it "should render the :edit template" do
      expect(response).to render_template :edit
    end

  end


  describe "POST #create" do

    context "with valid attributes" do

      it "should create new menu" do
        expect { post :create, { use_route: :roroacms, menu: FactoryGirl.attributes_for(:menu) } }.to change(Roroacms::Menu,:count).by(1)
      end

      it "should redirect to administrators#index" do
        post :create, { use_route: :roroacms, menu: FactoryGirl.attributes_for(:menu) }
        expect(response).to redirect_to "/admin/menus/#{assigns(:menu).id}/edit"
      end

    end

    context "with invalid attributes" do

      it "should not save the contact" do
        expect{post :create, { use_route: :roroacms, menu: FactoryGirl.attributes_for(:menu, name: nil) } }.to_not change(Roroacms::Menu,:count)
      end

      it "should re-render the new method" do
        post :create, { use_route: :roroacms, menu: FactoryGirl.attributes_for(:menu, name: nil) }
        expect(response).to render_template :index
      end

    end

  end

  describe "DELETE #destroy" do

    it "should delete the menu" do
      expect { delete :destroy, { use_route: :roroacms, id: menu } }.to change(Roroacms::Menu,:count).by(-1)
    end

  end

  describe "POST #save_menu" do

    it "should save the menu" do
      post :save_menu, { use_route: :roroacms, menuid: menu, data: nil }
      expect(response.body).to eq('done')
    end

  end

  describe "POST #ajax_dropbox" do

    it "should render a a visual representation of the created record" do
      post :ajax_dropbox, { use_route: :roroacms }
      expect(response).to render_template(:partial => 'roroacms/admin/menus/partials/_menu_dropdown')
    end

  end


end
