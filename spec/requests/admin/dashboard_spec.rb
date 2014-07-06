require 'rails_helper'

RSpec.describe "Admin::Dashboard", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET /admin" do

    before(:each) do
      visit admin_path
    end

    it "should display quick links" do
      expect(page).to have_content('Quick Links')
    end

    it "should display how many pages the system contains" do
      expect(page).to have_css('.dashboard-tile h1.text-left', :text => Post.where(:post_type => 'page').count)
      expect(page).to have_css('.dashboard-tile p', :text => 'Pages')
    end

    it "should disply how many articles the system contains" do
      expect(page).to have_css('.dashboard-tile h1.text-left', :text => Post.where(:post_type => 'post').count)
      expect(page).to have_css('.dashboard-tile p', :text => 'Articles')
    end

    it "should display how many comments the system contains" do
      expect(page).to have_css('.dashboard-tile h1.text-left', :text => Comment.all.count)
      expect(page).to have_css('.dashboard-tile p', :text => 'Comments')
    end

    context "comments area" do

      it "should display the latest 5 comments" do

        FactoryGirl.create(:comment)
        visit admin_path

        expect(page).to have_content('Latest 5 Comments')

      end

      it "should not display the latest comments panel" do

        visit admin_path
        expect(page).to_not have_content('Latest 5 Comments')

      end

    end

  end

end
