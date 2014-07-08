require 'rails_helper'

RSpec.describe Admin, :type => :model do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:user) { FactoryGirl.build(:admin) }

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
    expect(FactoryGirl.build(:admin, password: '123123123')).to be_valid
  end

  context "set defaults" do

    it "should return overlord as 'N'" do
      expect(admin.overlord).to eq('N')
    end

    it "should set the profile image" do
      expect(admin.avatar).to_not be_blank
    end

  end

  context "access levels" do 

    let(:levels) { Admin.access_levels }

    it "should return an array" do
      expect(levels).to be_a_kind_of(Array)
    end

    it "should include admin" do 
      expect(levels).to include('admin')
    end

  end

  it "should set the cover image to blank" do
    user.deal_with_cover({ has_cover_image: nil })
    expect(user.cover_picture).to be_blank
  end

end
