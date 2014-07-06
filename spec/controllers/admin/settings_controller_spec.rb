require 'rails_helper'

RSpec.describe Admin::SettingsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do 

		before(:each) do 
			get :index
		end

		it "should create the settings object" do 
			expect(assigns(:settings)).to_not be_nil
		end

		it "renders the :edit template" do
			expect(response).to render_template :index
		end
	end

	describe "POST #create" do
		
		before(:all) do 
			@settings = Setting.get_all
		end

		context "with valid attributes" do 

			it "creates saves the settings" do 
				@settings['articles_slug'] = '123123'
				@settings = @settings.symbolize_keys!
				post :create, @settings
				expect(Setting.get('articles_slug')).to eq('123123')
			end

			it "redirects to administrators#index" do 
				post :create, @settings
				expect(response).to redirect_to admin_settings_path
			end
		end

		context "with invalid attributes" do 

			it "does not save the settings" do 
				@settings['articles_slug'] = nil
				@settings = @settings.symbolize_keys!
				post :create, @settings
				expect(Setting.get('articles_slug')).to eq('news')
			end

			it "re-renders the index method" do 
				post :create, @settings
				expect(response).to render_template :index
			end

		end

	end

	describe "POST #create_user_group" do 

		it "creates a user group" do 
			post :create_user_group, {key: "123123"}
			expect(response).to render_template(:partial => 'admin/partials/_user_group_view')
		end
		
	end


end

