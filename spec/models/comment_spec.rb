require 'rails_helper'

RSpec.describe Comment, :type => :model do

	let(:comment) { FactoryGirl.create(:comment) }

	before(:each) do 
		@comment = FactoryGirl.build(:comment)
	end

	it "has a valid factory" do 
		expect(FactoryGirl.create(:comment)).to be_valid
	end

	it "is invalid without email" do 
		@comment.email = nil
		expect(@comment).to_not be_valid
	end

	it "is invalid without comment" do 
		@comment.comment = nil
		expect(@comment).to_not be_valid
	end

	it "is invalid without author" do 
		@comment.author = nil
		expect(@comment).to_not be_valid

	end

	it "sets default values before creating record" do 
		comment = FactoryGirl.create(:comment)
		expect(comment.comment_approved).to eq('N')
		expect(comment.submitted_on).to_not be_nil
	end

	context "bulk updating" do 

		before(:each) do 
			@record = FactoryGirl.create(:comment)
			@array = [@record.id, comment.id]
		end

		it "approves giveen records" do

			Comment.bulk_update({:to_do => 'approve', :comments => @array})

			expect(Comment.find(@record.id).comment_approved).to eq('Y') 
			expect(Comment.find(comment.id).comment_approved).to eq('Y') 
		
		end

		it "unapproves given records by id" do 

			Comment.bulk_update({:to_do => 'unapprove', :comments => @array})
			expect(Comment.find(@record.id).comment_approved).to eq('N') 
			expect(Comment.find(comment.id).comment_approved).to eq('N') 

		end


		it "marks giveen records as spam" do

			Comment.bulk_update({:to_do => 'mark_as_spam', :comments => @array})
			expect(Comment.find(@record.id).comment_approved).to eq('S') 
			expect(Comment.find(comment.id).comment_approved).to eq('S')

			expect(Comment.find(@record.id).is_spam).to eq('Y') 

		end

		it "deletes given records" do
			expect { Comment.bulk_update({:to_do => 'destroy', :comments => @array}) }.to change(Comment, :count).by(-2)
		end
	
	end


end