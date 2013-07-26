require 'spec_helper'

describe Comment do

	it "has a valid factory" do
		FactoryGirl.create(:comment).should be_valid
	end

	it "is invalid without author" do 
		FactoryGirl.build(:comment, author: nil).should_not be_valid
	end

	it "is invalid without comment" do 
		FactoryGirl.build(:comment, comment: nil).should_not be_valid
	end

	it "is invalid without email" do 
		FactoryGirl.build(:comment, email: nil).should_not be_valid
	end


end