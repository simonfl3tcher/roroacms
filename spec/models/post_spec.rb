require 'rails_helper'

RSpec.describe Post, :type => :model do

	before(:each) do 
		@post = FactoryGirl.create(:post)
	end

	it "has a valid factory" do 
		expect(FactoryGirl.create(:post)).to be_valid
	end

	it "is invalid without a post title" do 
		expect(FactoryGirl.build(:post, post_title: nil)).to_not be_valid
	end

	it "is invalid without a post slug" do 
		expect(FactoryGirl.build(:post, post_slug: nil)).to_not be_valid
	end

	it "is invalid without a unique slug" do
		expect(FactoryGirl.build(:post, post_slug: @post.post_slug)).to_not be_valid
	end

	it "is invalid if it the slug does not match /\A[A-Za-z0-9-]*\z/" do 
		expect(FactoryGirl.build(:post, post_slug: 'Hesfd sdfd sdf')).to_not be_valid
	end

	it "should return all pages" do 
		pages = Post.setup_and_search_posts({}, 'page')
		sample = pages.sample.post_type
		expect(pages).to_not be_nil
		expect(sample).to eq('page')
	end

	it "should return all posts" do 
		posts = Post.setup_and_search_posts({}, 'post')
		sample = posts.sample.post_type
		expect(posts).to_not be_nil
		expect(sample).to eq('post')
	end

	it "should return all tags" do 
		tags = Post.get_terms('tag')
		sample = tags.sample.term_anatomy.taxonomy
		expect(sample).to eq('tag')
	end

	it "should return all categories" do 
		categories = Post.get_terms('category')
		sample = categories.sample.term_anatomy.taxonomy
		expect(sample).to eq('category')
	end

	it "sets default values"
	it "saves additional data"
	
	context "autosaving" do 
		it "saves data in the background as a autosave record"
		it "saves the previous data as a record"
		it "restores the the saved data"
	end

	context "bulk updating" do 

		it "sets the given recods to published"
		it "sets the given records to draft"
		it "disables the given records"

	end

end