require 'rails_helper'

RSpec.describe Post, :type => :model do

	let(:post) { FactoryGirl.create(:post) }
	let(:invalid_post) { FactoryGirl.create(:invalid_post) }

	it "has a valid factory"
	it "is invalid without a post title"
	it "is invalid without a post slug"
	it "is invalid without a unique slug"
	it "is invalid if it the slug does not match /\A[A-Za-z0-9-]*\z/"
	it "should return all pages"
	it "should return all posts"
	it "should return all tags"
	it "should return all categories"


end