require 'spec_helper'

RSpec.describe Roroacms::Admin::SettingsController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET #index" do

    before(:each) do
      get :index, { use_route: :roroacms }
    end

    it "should create the settings object" do
      expect(assigns(:settings)).to_not be_nil
    end

    it "should render the :edit template" do
      expect(response).to render_template :index
    end

  end

  describe "POST #create" do

    before(:all) do
      @settings = Roroacms::Setting.get_all
    end

    context "with valid attributes" do

      it "should save the settings" do
        @settings['articles_slug'] = '123123'
        @settings = @settings.symbolize_keys!
        @settings[:use_route] = :roroacms
        post :create, @settings
        expect(Roroacms::Setting.get('articles_slug')).to eq('123123')
      end

      it "should redirect to administrators#index" do
        post :create, @settings
        expect(response).to redirect_to "/admin/settings"
      end

    end

    context "with invalid attributes" do

      it "should not save the settings" do
        @settings['articles_slug'] = nil
        @settings = @settings.symbolize_keys!
        @settings[:use_route] = :roroacms
        post :create, @settings
        expect(Roroacms::Setting.get('articles_slug')).to eq('news')
      end

      it "should re-render the index method" do
        post :create, @settings 
        expect(response).to render_template :index
      end

    end

  end

  describe "POST #create_user_group" do

    it "should create a user group" do
      post :create_user_group, { use_route: :roroacms, key: "123123" }
      expect(response).to render_template(:partial => 'roroacms/admin/partials/_user_group_view')
    end

  end
  
end
