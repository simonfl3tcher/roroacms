require 'rails_helper'

RSpec.describe Admin::TrashController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #index" do

	end

	describe "DELETE #destroy" do 

	end

	describe "POST #deal_with_form" do 

	end


end