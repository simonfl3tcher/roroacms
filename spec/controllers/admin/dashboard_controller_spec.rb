require 'rails_helper'

RSpec.describe Admin::DashboardController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do 

		before(:each) do 
			get :index
		end

		it "populates an array of the latest comments" do 
	    	expect(assigns(:comments)).to_not be_nil
		end
		
		it "renders the :index template" do 
			expect(response).to render_template :index
		end
	
	end

end