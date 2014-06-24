require 'rails_helper'

RSpec.describe Menu, :type => :model do

	let(:menu) { FactoryGirl.create(:menu) }

	before(:each) do 
		@menu = FactoryGirl.create(:menu)
	end

	it "is invalid without name" do 
		@menu.name = nil
		expect(@menu).to_not be_valid
	end

	it "is invalid without key" do 
		@menu.key = nil
		expect(@menu).to_not be_valid
	end

end