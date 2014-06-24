require 'rails_helper'

RSpec.describe Trash, :type => :model do

	let(:disabled_post) { FactoryGirl.create(:disabled_post) }
	let(:disabled_page) { FactoryGirl.create(:disabled_page) }


	it "should delete posts"
	it "should reinstate posts"

	it "should reinstate pages"
	it "should delete pages"
	
end