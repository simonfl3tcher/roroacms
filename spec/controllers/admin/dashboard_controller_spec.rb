require 'rails_helper'

RSpec.describe Admin::DashboardController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do 

		it "populates an array of the latest comments" do 
			get :index
	    	expect(assigns(:comments)).to_not be_nil
		end
		
		it "renders the :index template" do 
			get :index 
			expect(response).to render_template :index
		end
	
	end

end