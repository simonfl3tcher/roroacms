require 'spec_helper'

RSpec.describe "Admin::Comments", :type => :request do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:comment) { FactoryGirl.create(:comment) }
  before { sign_in(admin) }

  describe "GET /admin/comments" do

    before(:each) do
      visit "/admin/comments"
    end

    it "should display comments" do
      expect(page).to have_content "Comments"
    end

    it "should allow admin to edit content" do

      expect(page).to have_css('table .fa.fa-pencil')
      first(:linkhref, "/admin/comments/#{comment.id}/edit").click

      expect(current_path).to eq("/admin/comments/#{comment.id}/edit")
      expect(page).to have_content('Edit Comment')

    end

    it "should allow admin to mark the comment as spam" do

      expect(page).to have_css('table .fa.fa-fire')

      first(:linkhref, "/admin/comments/#{comment.id}/mark_as_spam").click

      expect(current_path).to eq("/admin/comments")
      expect(page).to have_content('Comment was successfully marked as spam')

    end

  end

  describe "GET /admin/comment/#id" do

    it "should go to edit comment page" do

      visit "/admin/comments"
      first(:linkhref, "/admin/comments/#{comment.id}/edit").click

      expect(current_path).to eq("/admin/comments/#{comment.id}/edit")
      expect(page).to have_content('Edit Comment')

    end

    context "Edit form" do

      let(:new_comment) { FactoryGirl.build(:comment) }

      before(:each) do
        visit "/admin/comments/#{comment.id}/edit"
      end

      it "should update the user" do

        fill_in 'comment_author', :with => new_comment.author
        click_button 'Save'

        expect(current_path).to eq("/admin/comments/#{comment.id}/edit")
        expect(page).to have_content('Comment was successfully updated')

      end

      it "should not allow blank values unless website is blank" do

        fill_in 'comment_author', :with => ''
        click_button 'Save'

        expect(page).to have_selector('.help-block.error')

      end

    end

  end

end
