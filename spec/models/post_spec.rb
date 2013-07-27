require 'spec_helper'

describe Post do

	it "has a valid factory" do
		FactoryGirl.create(:post).should be_valid
	end

	it "is invalid without post title" do 
		FactoryGirl.build(:post, post_title: nil).should_not be_valid
	end

	it "is invalid without a unique slug" do 
		example = FactoryGirl.create(:post, post_title: "Drake")
		treysongz = FactoryGirl.build(:post, post_title: "Trey")

		treysongz.should_not be_valid
		treysongz.should have(1).error_on(:post_slug)  
	end

	it "is invalid if slug has spaces" do

		FactoryGirl.build(:post, post_slug: "hello there").should_not be_valid
		FactoryGirl.build(:post, post_slug: "hello-there").should be_valid

	end

end