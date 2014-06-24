require 'rails_helper'

RSpec.describe Term, :type => :model do

	let(:term) { FactoryGirl.create(:term) }
	let(:invalid_term) { FactoryGirl.create(:invalid_term) }

	it "has a valid factory"
	it "is invalid without a name"
	it "is invalid without a slug"
	it "is invalid without a unique slug"
	it "is invalid if it the slug does not match /\A[A-Za-z0-9-]*\z/"
	it "returns the redirect url via the type of term"
	it "returns type for front end visuals"
	it "updates the slug for subcategories"
	it "destroys the given terms"

end