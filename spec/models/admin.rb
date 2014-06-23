require 'rails_helper'

RSpec.describe Admin, :type => :model do

	let(:admin) { FactoryGirl.create(:admin) }
	
	before(:each) do 
	    let(:user) { FactoryGirl.build(:admin) }
	    sign_in(admin)
	end

	it "has a valid factory" do 
		expect(user).to be_valid
	end

	it "is invalid without a username" do 
		expect(FactoryGirl.build(:admin, username: nil)).to_not be_valid
	end

	it "is invalid without a unique username" do 
		expect(FactoryGirl.build(:admin, username: admin.username)).to_not be_valid
	end

	it "is invalid without a access_level" do 
		expect(FactoryGirl.build(:admin, access_level: nil)).to_not be_valid
	end

	it "is invalid without a password" do 
		expect(FactoryGirl.build(:admin, password: '')).to_not be_valid
	end

	it "is invalid without a password of a length of 6-128" do 
		expect(FactoryGirl.build(:admin, password: '123')).to_not be_valid
	end

	it "is valid with a password of a length between 6-128" do 
		expect(FactoryGirl.build(:admin, password: '123123123')).to_not be_valid
	end

	it "returns overlord as 'N'" do 
		user.deal_with_abnormalaties
		expect(user.overlord).to eq('N')
	end

	it "should set the profile image" do 
		user.deal_with_abnormalaties
		expect(user.avatar).to_not be_blank
	end

	it "should return an array if access levels" do 
		levels = Admin.access_levels
		expect(levels).to be(Array)
		expect(levels).to include('Admin')
	end

	it "should set the cover image to blank" do 
		# deal_with_cover
		user.deal_with_cover({:has_cover_image => nil})
		expect(user.cover_picture).to be_blank
	end

end