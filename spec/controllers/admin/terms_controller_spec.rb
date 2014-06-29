require 'rails_helper'

RSpec.describe Admin::TermsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	describe "GET #categories" do

	end

	describe "GET #tags" do 

	end

	describe "POST #create" do 

	end

	describe "PUT #edit" do 

	end

	describe "PUT #update" do 

	end

	describe "DELETE #destroy" do 

	end

	describe "POST #bulk_update" do 

	end

end