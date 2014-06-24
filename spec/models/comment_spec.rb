require 'rails_helper'

RSpec.describe Comment, :type => :model do

	let(:comment) { FactoryGirl.create(:comment) }
	let(:invalid_comment) { FactoryGirl.create(:invalid_comment) }

	it "has a valid factory"
	it "is invalid without email"
	it "is invalid without comment"
	it "is invalid without comment"
	it "sets default values before creating record"
	it "unapproves giveen records"
	it "approves giveen records"
	it "marks giveen records as spam"
	it "deletes given records"

end