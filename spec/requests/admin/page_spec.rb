require 'rails_helper'

# very similar to the article_request_spec.rb as they are virtually the same!

RSpec.describe "Admin::Pages", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:record) { FactoryGirl.create(:post, post_type: 'page') }
  before { sign_in(admin) }

  describe "GET /admin/pages" do

    before(:each) do
      visit admin_pages_path
    end

    it "should show pages" do
      expect(page).to have_content('Pages')
      expect(page).to have_content(record.post_title)
    end

    it "should have a button to allow user to create new article" do

      find('#add-new-page').click
      
      expect(current_path).to eq(new_admin_page_path)
      expect(page).to have_content('Create New Page')

    end

  end

  describe "GET /admin/pages/new" do

    let(:article) { FactoryGirl.build(:post, post_type: 'page') }

    before(:each) do
      visit new_admin_page_path
    end

    it "should create new page" do

      fill_in 'post_post_title', :with => article.post_title
      fill_in 'post_post_slug', :with => article.post_slug
      click_button 'Save'

      expect(current_path).to eq(admin_pages_path)
      expect(page).to have_content('success')

    end

    it "should not allow title to be blank" do

      click_button 'Save'

      expect(current_path).to eq(admin_pages_path)
      expect(page).to have_selector('.help-block.error')
      expect(page).to have_content('Title is required')
      expect(page).to have_content('Url is required')

    end

    it "should not have the option to add categories" do
      expect(page).to_not have_content('Tags & Categories')
    end

    it "should not have any revisions" do
      expect(page).to have_content('There are no revisions')
    end

  end

  describe "PUT /admin/page/#id" do

    before(:each) do
      visit edit_admin_page_path(record.id)
    end

    it "should update the page" do

      fill_in 'post_post_content', :with => Faker::Lorem.paragraph(5)
      click_button 'Save'

      expect(current_path).to eq(edit_admin_page_path(record.id))
      expect(page).to have_content('Success')

    end

    it "should not allow you to update the page with no title" do

      fill_in 'post_post_title', :with => ''
      click_button 'Save'

      expect(current_path).to eq(admin_page_path(record.id))
      expect(page).to have_selector('.help-block.error')
      expect(page).to have_content('Title is required')

    end

  end

end
