require 'spec_helper'

describe Banner do 

	it "has a valid factory" do
		FactoryGirl.create(:banner).should be_valid
	end

	it "is invalid with no name" do 

		FactoryGirl.build(:admin, name: "").should_not be_valid
		FactoryGirl.build(:admin, email: "Banner 1").should be_valid

	end

	it "is invalid with no image" do 

		FactoryGirl.build(:admin, image: "").should_not be_valid
		FactoryGirl.build(:admin, email: "image.png").should be_valid

	end

	describe "class relations" do
		it { should have_many(:term_relationships_banners)}
		it { should have_many(:terms)}
	end

end
