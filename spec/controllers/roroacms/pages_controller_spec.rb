require 'spec_helper'

RSpec.describe Roroacms::PagesController, :type => :controller do

  let!(:record) { FactoryGirl.create(:post, post_type: 'page', post_status: 'Published') }
  let!(:record_draft) { FactoryGirl.create(:post, post_type: 'page', post_status: 'Draft') }

  describe "GET /pages/#id" do

    it "should show any post" do
      get :show, { use_route: :roroacms, id: record_draft.id }
      expect(response.status).to eq(302)
      expect(response).to redirect_to "#{record_draft.structured_url}?admin_preview=true"
    end

  end

  describe "dynamic_page" do

    it "should route to the necessary page" do
      url = record.structured_url[1..-1]
      get :dynamic_page, { use_route: :roroacms, slug: url }
      expect(response.status).to eq(200)
    end

    it "should render 404" do
      url = record_draft.structured_url[1..-1]
      get :dynamic_page, { use_route: :roroacms, slug: url }
      expect(response.status).to eq(404)
    end

  end

end
