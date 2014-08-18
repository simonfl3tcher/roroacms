require 'spec_helper'

RSpec.describe "Admin::Terms", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET /admin/article/categories" do

    let!(:category) { FactoryGirl.create(:term) }
    let!(:term){ FactoryGirl.build(:term) }

    before(:each) do
      visit "/admin/article/categories"
    end

    it "should show categories and allow user to updated individual records" do

      expect(page).to have_content('Categories')
      expect(page).to have_content(category.name)

      find(:xpath, "//a[@href='/admin/terms/#{category.id}/edit']").click

      expect(page).to have_content('Article Category')

    end

    it "should have a form to create a category" do
      expect(page).to have_css('form#new_term')
    end

    context "Creating a category" do

      it "should create a new category" do

        fill_in "term_name", :with => term.name
        fill_in "term_slug", :with => term.slug
        click_button 'Save'

        expect(current_path).to eq("/admin/article/categories")
        expect(page).to have_content('Success')

      end

      it "should not allow you to create a category with no name" do

        fill_in "term_slug", :with => term.slug
        click_button 'Save'

        expect(current_path).to eq("/admin/article/categories")
        expect(page).to have_content('Error')

      end

      it "should allow you to create a category with no slug" do

        fill_in "term_name", :with => term.name
        fill_in "term_slug", :with => ''
        click_button 'Save'

        expect(current_path).to eq("/admin/article/categories")
        expect(page).to have_content('Success')

      end

    end

    context "Editing a category" do

      before(:each) do
        visit "/admin/terms/#{category.id}/edit"
      end

      it "should allow user to update the name" do

        expect(page).to have_content('Article Category')

        fill_in "term_name", :with => term.name
        click_button 'Save'

        expect(current_path).to eq("/admin/terms/#{category.id}/edit")
        expect(page).to have_content('Success')

      end

      it "should not allow user to update a category with no name" do

        fill_in "term_name", :with => ''
        click_button 'Save'

        expect(current_path).to eq("/admin/terms/#{category.id}")
        expect(page).to have_selector('.help-block.error')

      end

    end

  end


  describe "GET /admin/article/tags" do

    let!(:tag) { FactoryGirl.create(:tag) }
    let!(:term){ FactoryGirl.build(:tag) }

    before(:each) do
      visit "/admin/article/tags"
    end


    it "should show tags" do

      expect(page).to have_content('Tags')
      expect(page).to have_content(tag.name)

      find(:xpath, "//a[@href='/admin/terms/#{tag.id}/edit']").click

      expect(page).to have_content('Article Tag')

    end

    it "should have a form to create a tag" do
      expect(page).to have_css('form#new_term')
    end

    context "Creating a tag" do

      it "should create a new tag" do

        fill_in "term_name", :with => term.name
        fill_in "term_slug", :with => term.slug
        click_button 'Save'

        expect(current_path).to eq("/admin/article/tags")
        expect(page).to have_content('Success')

      end

      it "should not allow you to create a tag with no name" do

        fill_in "term_slug", :with => term.slug
        click_button 'Save'

        expect(current_path).to eq("/admin/article/tags")
        expect(page).to have_content('Error')

      end

      it "should allow you to create a tag with no slug" do

        fill_in "term_name", :with => term.name
        fill_in "term_slug", :with => ''
        click_button 'Save'

        expect(current_path).to eq("/admin/article/tags")
        expect(page).to have_content('Success')

      end

    end

    context "Editing a tag" do

      before(:each) do
        visit "/admin/terms/#{tag.id}/edit"
      end

      it "should allow user to update the name" do

        expect(page).to have_content('Article Tag')

        fill_in "term_name", :with => term.name
        click_button 'Save'

        expect(current_path).to eq("/admin/terms/#{tag.id}/edit")
        expect(page).to have_content('Success')

      end

      it "should not allow user to update a tag with no name" do

        fill_in "term_name", :with => ''
        click_button 'Save'

        expect(current_path).to eq("/admin/terms/#{tag.id}")
        expect(page).to have_selector('.help-block.error')

      end

    end

  end

end
