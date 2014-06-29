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

	it "it create the slug out of the title if left blank" do 
		expect(FactoryGirl.build(:post, post_slug: nil)).to be_valid
	end

	it "is invalid without a unique slug" do
		expect(FactoryGirl.build(:post, post_slug: @post.post_slug)).to_not be_valid
	end

	it "formats the slug to match /\A[A-Za-z0-9\-]*\z/" do 
		expect(FactoryGirl.build(:post, post_slug: 'Hesfd sdfd sdf')).to be_valid
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

	it "sets default values" do 
		expect(@post.post_status).to eq('Draft')
		expect(@post.post_slug).to_not be_nil
	end
	
	context "autosaving" do 

		it "saves data in the background as a autosave record" do 
			post = Post.create(@post.attributes)
			ret = Post.do_autosave({:post => @post.attributes.symbolize_keys}, post)
			expect(ret).to eq("nothing changed")

			post[:post_title] = 'testing rspec'
			ret = Post.do_autosave({:post => @post.attributes.symbolize_keys}, post)
			expect(ret).to eq("passed")

		end

		it "saves the previous data as a record" do 
			p = Post.find(@post.id) 
			post_title = p.post_title
			p.post_title = 'fff'

			expect{p.save}.to change(Post,:count).by(1)

		end

	end

	context "bulk updating" do 

		before(:each) do 
			@record = FactoryGirl.create(:post)
			@array = [@record.id, @post.id]
		end

		it "sets the given recods to published" do 
			Post.bulk_update({:to_do => 'publish', :pages => @array}, 'pages')

			expect(Post.find(@record.id).post_status).to eq('Published') 
			expect(Post.find(@post.id).post_status).to eq('Published')
		end

		it "sets the given records to draft" do
			Post.bulk_update({:to_do => 'draft', :pages => @array}, 'pages')

			expect(Post.find(@record.id).post_status).to eq('Draft') 
			expect(Post.find(@post.id).post_status).to eq('Draft')
		end

		it "puts the given records into trash" do
			Post.bulk_update({:to_do => 'move_to_trash', :pages => @array}, 'pages')

			expect(Post.find(@record.id).disabled).to eq('Y') 
			expect(Post.find(@post.id).disabled).to eq('Y')
		end

	end

end