require 'spec_helper'

RSpec.describe Roroacms::Admin::DashboardController, :type => :controller do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET #index" do

    before(:each) do
      get :index, { use_route: :roroacms }
    end

    it "should populate an array of the latest comments" do
      expect(assigns(:comments)).to_not be_nil
    end

    it "should render the :index template" do
      expect(response).to render_template :index
    end

  end

end
