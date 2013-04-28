require 'spec_helper'

describe Admin do 

	it "has a valid factory" do
		FactoryGirl.create(:admin).should be_valid
	end

	it "is invalid with incorrect email address" do 

		FactoryGirl.build(:admin, email: "simon").should_not be_valid
		FactoryGirl.build(:admin, email: "simon@logicdesign.co.uk").should be_valid

	end

	it "Validates uniqueness of the email address" do

		simon = FactoryGirl.create(:admin, email: "simon@logicdesign.co.uk")
		keith = FactoryGirl.build(:admin, email: "simon@logicdesign.co.uk")

		keith.should_not be_valid

	end

	it "is invalid without a password" do
		m = FactoryGirl.build(:admin, password: nil).should_not be_valid
	end

	describe "class relations" do

		it { should have_many(:posts)}

	end

end