require 'rails_helper'

RSpec.describe "Admin::Terms", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }   

    describe "GET /admin/article/categories" do

      let!(:category) { FactoryGirl.create(:term) }
      let!(:term){ FactoryGirl.build(:term) }

      it "should show categories and allow user to updated individual records" do 
        visit admin_article_categories_path
        expect(page).to have_content('Categories')
        expect(page).to have_content(category.name)
        find(:xpath, "//a[@href='/admin/terms/#{category.id}/edit']").click
        expect(page).to have_content('Article Category')
      end

      it "should have a form to create a category" do 
        visit admin_article_categories_path
        expect(page).to have_css('form#new_term')
      end

      context "Creating a category" do 

        before(:each) do 
          visit admin_article_categories_path
        end

        it "should create a new category" do 
          fill_in "term_name", :with => term.name
          fill_in "term_slug", :with => term.slug
          click_button 'Save'

          expect(current_path).to eq(admin_article_categories_path)
          expect(page).to have_content('Success')
        end

        it "should not allow you to create a category with no name" do 
          fill_in "term_slug", :with => term.slug
          click_button 'Save'
          expect(current_path).to eq(admin_article_categories_path)
          expect(page).to have_content('Error')
        end

        it "should allow you to create a category with no slug" do 
          fill_in "term_name", :with => term.name
          fill_in "term_slug", :with => ''
          click_button 'Save'
          expect(current_path).to eq(admin_article_categories_path)
          expect(page).to have_content('Success')
        end

      end

      context "Editing a category" do 

        it "should user to update the name" do 
          visit edit_admin_term_path(category.id)
          expect(page).to have_content('Article Category')

          fill_in "term_name", :with => term.name
          click_button 'Save'

          expect(current_path).to eq(edit_admin_term_path(category.id))
          expect(page).to have_content('Success')
        end

        it "should not allow user to update a category with no name" do 
          visit edit_admin_term_path(category.id)
          fill_in "term_name", :with => ''
          click_button 'Save'

          expect(current_path).to eq(admin_term_path(category.id))
          expect(page).to have_selector('.help-block.error')
        end

      end

    end


    describe "GET /admin/article/tags" do

      let!(:tag) { FactoryGirl.create(:tag) }
      let!(:term){ FactoryGirl.build(:tag) }

      it "should show tags" do 
        visit admin_article_tags_path
        expect(page).to have_content('Tags')
        expect(page).to have_content(tag.name)
        find(:xpath, "//a[@href='/admin/terms/#{tag.id}/edit']").click
        expect(page).to have_content('Article Tag')
      end

      it "should have a form to create a tag" do 
        visit admin_article_tags_path
        expect(page).to have_css('form#new_term')
      end

      context "Creating a tag" do 

        before(:each) do 
          visit admin_article_tags_path
        end

        it "should create a new tag" do 
          fill_in "term_name", :with => term.name
          fill_in "term_slug", :with => term.slug
          click_button 'Save'

          expect(current_path).to eq(admin_article_tags_path)
          expect(page).to have_content('Success')
        end

        it "should not allow you to create a tag with no name" do 
          fill_in "term_slug", :with => term.slug
          click_button 'Save'
          expect(current_path).to eq(admin_article_tags_path)
          expect(page).to have_content('Error')
        end

        it "should allow you to create a tag with no slug" do 
          fill_in "term_name", :with => term.name
          fill_in "term_slug", :with => ''
          click_button 'Save'
          expect(current_path).to eq(admin_article_tags_path)
          expect(page).to have_content('Success')
        end

      end

      context "Editing a tag" do 

        it "should user to update the name" do 
          visit edit_admin_term_path(tag.id)
          expect(page).to have_content('Article Tag')

          fill_in "term_name", :with => term.name
          click_button 'Save'

          expect(current_path).to eq(edit_admin_term_path(tag.id))
          expect(page).to have_content('Success')
        end

        it "should not allow user to update a tag with no name" do 
          visit edit_admin_term_path(tag.id)
          fill_in "term_name", :with => ''
          click_button 'Save'

          expect(current_path).to eq(admin_term_path(tag.id))
          expect(page).to have_selector('.help-block.error')
        end

      end

    end


end