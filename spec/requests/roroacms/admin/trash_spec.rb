require 'spec_helper'

RSpec.describe "Admin::Trash", :type => :request do

  let!(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET /admin/trash" do

    before(:each) do
      visit "/admin/trash"
    end

    it "should display trash" do
      expect(page).to have_content "Trash"
    end

    it "should show no records message" do
      expect(page).to have_content('The trash can is currently empty')
    end

    context "with posts or pages in the trash can" do

      let!(:post_post) { FactoryGirl.create(:disabled_post) }
      let!(:post_page) { FactoryGirl.create(:disabled_page) }

      before(:each) do
        visit "/admin/trash"
      end

      it "should have have post on view" do
        expect(page).to have_content post_post.post_title
      end

      it "should have page on view" do
        expect(page).to have_content post_page.post_title
      end

      it "should display the total count of pages" do
        expect(page).to have_content("Total Count #{Roroacms::Post.where(:disabled => 'Y', :post_type => 'page').count}")
      end

      it "should display the total count of posts" do
        expect(page).to have_content("Total Count #{Roroacms::Post.where(:disabled => 'Y', :post_type => 'post').count}")
      end

      it "should delete all post records" do

        find(:css, "#posts").click_link("Delete all")

        expect(current_path).to eq("/admin/trash")
        expect(page).to have_content('All posts were removed from the trash can')
        expect(page).to have_content post_page.post_title

      end

      it "should delete all page records" do

        find(:css, "#pages").click_link("Delete all")

        expect(current_path).to eq("/admin/trash")
        expect(page).to have_content('All pages were removed from the trash can')

      end

    end

  end

end
