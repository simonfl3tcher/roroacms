require 'rails_helper'

RSpec.describe Admin::TermsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	before { sign_in(admin) }

	before(:each) do
		@term = FactoryGirl.create(:term)
	end

	describe "GET #categories" do

		it "should set type to category"
		it "should render the view template"

	end

	describe "GET #tags" do 

		it "should set type to tag"
		it "should render the view template"

	end

	describe "POST #create" do 

		context "with valid attributes" do 
			it "creates new term"
			it "redirects to article/categories"
			it "redirects to article/tags"
		end

		context "with invalid attributes" do 
			it "does not save the contact"
			it "redirects to article/categories"
			it "redirects to article/tags"
		end

	end

	describe "PUT #edit" do 

		it "should get the term object"
		it "renders the :edit template"

	end

	describe "PUT #update" do 

		context "with valid attributes" do 
			it "creates new term"
			it "renders the :edit template"
		end

		context "with invalid attributes" do 
			it "does not save the contact"
			it "renders the :edit template"
		end

	end

	describe "DELETE #destroy" do 

		it "deletes the term"
		it "redirects to article/categories"
		it "redirects to article/tags"

	end

	describe "POST #bulk_update" do 

		before(:each) do 
			@array = [@term.id, FactoryGirl.create(:term).id]
		end

		it "deletes the given terms"

	end

end