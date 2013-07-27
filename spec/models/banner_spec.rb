require 'spec_helper'

describe Banner do 

	it "has a valid factory" do
		FactoryGirl.create(:banner).should be_valid
	end

	it "is invalid with no name" do 

		FactoryGirl.build(:banner, name: "").should_not be_valid
		FactoryGirl.build(:banner, name: "Banner 1").should be_valid

	end

	it "is invalid with no image" do 

		FactoryGirl.build(:banner, image: "").should_not be_valid
		FactoryGirl.build(:banner, image: "image.png").should be_valid

	end

end
