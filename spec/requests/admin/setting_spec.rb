require 'rails_helper'

RSpec.describe "Admin::Settings", :type => :request do

  let(:admin) { FactoryGirl.create(:admin) }
  before { sign_in(admin) }

  describe "GET /admin/settings" do

    before(:each) do
      visit admin_settings_path
    end

    it "should display settings" do
      expect(page).to have_content('Settings')
    end

    context "should have different options for different settings" do

      it "should have general settings" do
        expect(page).to have_content('General')
      end

      it "should have email settings" do
        expect(page).to have_content('Email Configuration')
      end

      it "should have comments" do
        expect(page).to have_content('Comments')
      end

      it "should have search engine optimisation" do
        expect(page).to have_content('Search Engine Optimisation')
      end

      it "should have user groups" do
        expect(page).to have_content('User Groups')
      end

    end

    it "should update the settings" do

      fill_in "articles_slug", :with => 'testing'
      find('button[type=submit]').click

      expect(current_path).to eq(admin_settings_path)
      expect(page).to have_content('Success')

    end

    context "invalid attributes" do

      it "should not update if article slug is left blank" do

        fill_in "articles_slug", :with => ''
        find('button[type=submit]').click

        expect(current_path).to eq(admin_settings_path)
        expect(page).to_not have_content('Success')
        expect(page).to have_selector('.help-block.error')

      end

      it "should not update if category_slug is left blank" do

        fill_in "category_slug", :with => ''
        find('button[type=submit]').click

        expect(current_path).to eq(admin_settings_path)
        expect(page).to_not have_content('Success')
        expect(page).to have_selector('.help-block.error')

      end

      it "should not update if tag_slug is left blank" do

        fill_in "tag_slug", :with => ''
        find('button[type=submit]').click

        expect(current_path).to eq(admin_settings_path)
        expect(page).to_not have_content('Success')
        expect(page).to have_selector('.help-block.error')

      end

      it "should not update if smtp_username is left blank" do

        fill_in "smtp_username", :with => ''
        find('button[type=submit]').click

        expect(current_path).to eq(admin_settings_path)
        expect(page).to_not have_content('Success')
        expect(page).to have_selector('.help-block.error')

      end

      it "should not update if smtp_password is left blank" do

        fill_in "smtp_password", :with => ''
        find('button[type=submit]').click

        expect(current_path).to eq(admin_settings_path)
        expect(page).to_not have_content('Success')
        expect(page).to have_selector('.help-block.error')

      end

    end

  end

end
