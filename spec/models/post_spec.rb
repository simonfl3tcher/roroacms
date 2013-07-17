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
	
	describe "filter post title by letter" do

		before :each do
			@example = FactoryGirl.create(:post, post_title: "Drake", post_slug: "1232312312312")
			@treysongz = FactoryGirl.create(:post, post_title: "Trey", post_slug: "09809890")
			@usher = FactoryGirl.create(:post, post_title: "Usher", post_slug: "-09087576")
		end	

		context "matching letters" do
			it "returns a sorted array of results that match" do
				Post.by_letter("U").should == [@usher]
			end
		end

		context "non-matching letters" do
			it "does not return contacts that dont start with the provided letter" do
				Post.by_letter("U").should_not include @example
			end
		end
	end

	describe "class relations" do

		it { should have_many(:term_relationships)}
		it { should have_many(:terms)}
		it { should have_many(:post_abstractions)}
		it { should belong_to(:admin)}

	end

end