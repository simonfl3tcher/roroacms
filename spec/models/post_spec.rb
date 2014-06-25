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
		sample = categories.sample.term_anatomy.taxonomy
		expect(sample).to eq('tag')
	end

	it "should return all categories" do 
		categories = Post.get_terms('category')
		sample = categories.sample.term_anatomy.taxonomy
		expect(sample).to eq('category')
	end

end