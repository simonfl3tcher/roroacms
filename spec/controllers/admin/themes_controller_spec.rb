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
		
		it "deletes the given theme" do 
			delete :destroy, id: 'roroa1'
			expect(File.directory?("#{Rails.root}/app/views/theme/roroa1")).to be_false 
		end

		it "redirects to themes#index" do 
			delete :destroy, id: 'roroa1'
			expect(response).to redirect_to admin_themes_path
		end

	end

end