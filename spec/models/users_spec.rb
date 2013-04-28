require 'spec_helper'

describe User do
	
	it "has a valid factory" do
		FactoryGirl.create(:user).should be_valid
	end

	it "is invalid without first and last name" do
		FactoryGirl.build(:user, first_name: nil, last_name: nil).should_not be_valid
	end

	it "is invalid with incorrect email address" do 

		FactoryGirl.build(:user, email: "simon").should_not be_valid
		FactoryGirl.build(:user, email: "simon@logicdesign.co.uk").should be_valid

	end

end