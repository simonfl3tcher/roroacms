require 'rails_helper'

RSpec.describe Admin::ThemesController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do

		it "sets the current theme used by roroa" do 
			get :index
	    	expect(assigns(:current)).to_not be_nil
	    end

	    it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end 

	end

	describe "POST #create" do 

		it "resets the current theme" do
			post :create, theme: 'roroa1'
			expect(Setting.get('theme_folder')).to eq('roroa1')
		end

		it "redirects to themes#index" do 
			post :create, theme: 'roroa1'
			expect(response).to redirect_to admin_themes_path
		end

	end

	describe "DELETE #destroy" do 

		before(:each) do 
			Dir.mkdir("#{Rails.root}/app/views/theme/testing") unless File.exists?("#{Rails.root}/app/views/theme/testing")
			delete :destroy, id: 'testing'
		end
		
		it "deletes the given theme" do 
			expect(File.directory?("#{Rails.root}/app/views/theme/testing")).to be_falsey
		end

		it "redirects to themes#index" do 
			expect(response).to redirect_to admin_themes_path
		end

	end

end