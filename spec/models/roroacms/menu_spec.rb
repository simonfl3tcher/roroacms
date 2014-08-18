require 'spec_helper'

RSpec.describe Roroacms::Menu, :type => :model do

  let!(:menu) { FactoryGirl.create(:menu) }

  it "is invalid without name" do
    menu.name = nil
    expect(menu).to_not be_valid
  end

  it "is invalid without key" do
    menu.key = nil
    expect(menu).to_not be_valid
  end

end
