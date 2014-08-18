require 'spec_helper'

RSpec.describe "Admin::Articles", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  let!(:article) { FactoryGirl.create(:post, post_type: 'post') }
  before { sign_in(admin) }

  describe "GET /admin/articles" do

    before(:each) do
      visit "/admin/articles"
    end

    it "should show articles" do
      expect(page).to have_content('Articles')
      expect(page).to have_content(article.post_title)
    end

    it "should have a button to allow user to create new article" do

      find('#add-new-article').click

      expect(current_path).to eq("/admin/articles/new")
      expect(page).to have_content('Create New Article')

    end

  end


  describe "GET /admin/articles/new" do

    let(:article_build) { FactoryGirl.build(:post, post_type: 'post') }

    before(:each) do
      visit "/admin/articles/new"
    end

    it "should create new article" do

      fill_in 'post_post_title', :with => article_build.post_title
      fill_in 'post_post_slug', :with => article_build.post_slug
      click_button 'Save'

      expect(current_path).to eq("/admin/articles")
      expect(page).to have_content('success')

    end

    it "should not allow title to be blank" do

      click_button 'Save'

      expect(current_path).to eq("/admin/articles")
      expect(page).to have_selector('.help-block.error')
      expect(page).to have_content('Title is required')
      expect(page).to have_content('Url is required')

    end

    it "should have the option to add categories" do
      expect(page).to have_content('Tags & Categories')
    end

    it "should have the ability to add search engine data" do

      fill_in 'post_post_title', :with => article_build.post_title
      fill_in 'post_post_seo_title', :with => article_build.post_title
      click_button 'Save'

      expect(current_path).to eq("/admin/articles")
      expect(page).to have_content('success')
      expect(page).to have_content(article_build.post_title)

    end

    it "should not have any revisions" do
      expect(page).to have_content('There are no revisions')
    end

  end

  describe "PUT /admin/article/#id" do

    before(:each) do
      visit "/admin/articles/#{article.id}/edit"
    end

    it "should update the article" do

      fill_in 'post_post_content', :with => Faker::Lorem.paragraph(5)
      click_button 'Save'

      expect(current_path).to eq("/admin/articles/#{article.id}/edit")
      expect(page).to have_content('Success!')

    end

    it "should not allow you to update the article with no title" do

      fill_in 'post_post_title', :with => ''
      click_button 'Save'

      expect(current_path).to eq("/admin/articles/#{article.id}")
      expect(page).to have_selector('.help-block.error')
      expect(page).to have_content('Title is required')

    end

  end

end
