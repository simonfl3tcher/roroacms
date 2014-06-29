require 'rails_helper'

RSpec.describe Admin::ThemesController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do 

	end

	describe "POST #create" do 

	end

	describe "DELETE #destroy" do 

	end

end