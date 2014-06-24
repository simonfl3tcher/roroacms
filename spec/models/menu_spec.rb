require 'rails_helper'

RSpec.describe Menu, :type => :model do

	let(:menu) { FactoryGirl.create(:menu) }

	it "is invalid without name"
	it "is invalid without key"
	it "saves the menu"

end