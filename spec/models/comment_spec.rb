require 'rails_helper'

RSpec.describe Comment, :type => :model do

  let(:comment) { FactoryGirl.create(:comment) }

  it "has a valid factory" do
    expect(FactoryGirl.create(:comment)).to be_valid
  end

  context "invalid" do

    let!(:comment_build) { FactoryGirl.build(:comment) }

    it "is invalid without email" do
      comment_build.email = nil
      expect(comment_build).to_not be_valid
    end

    it "is invalid without comment" do
      comment_build.comment = nil
      expect(comment_build).to_not be_valid
    end

    it "is invalid without author" do
      comment_build.author = nil
      expect(comment_build).to_not be_valid

    end

  end

  it "sets default values before creating record" do
    expect(comment.comment_approved).to eq('N')
    expect(comment.submitted_on).to_not be_nil
  end

  context "bulk updating" do

    let!(:record) { FactoryGirl.create(:comment) }
    let!(:array) { [record.id, comment.id] }

    it "should approve given records" do

      Comment.bulk_update({ to_do: 'approve', comments: array})

      expect(Comment.find(record.id).comment_approved).to eq('Y')
      expect(Comment.find(comment.id).comment_approved).to eq('Y')

    end

    it "should unapprove given records by id" do

      Comment.bulk_update({ to_do: 'unapprove', comments: array})
      expect(Comment.find(record.id).comment_approved).to eq('N')
      expect(Comment.find(comment.id).comment_approved).to eq('N')

    end

    it "should mark given records as spam" do

      Comment.bulk_update({ to_do: 'mark_as_spam', comments: array})
      expect(Comment.find(record.id).comment_approved).to eq('S')
      expect(Comment.find(comment.id).comment_approved).to eq('S')

      expect(Comment.find(record.id).is_spam).to eq('Y')

    end

    it "should delete given records" do
      expect { Comment.bulk_update({ to_do: 'destroy', comments: array}) }.to change(Comment, :count).by(-2)
    end

  end

end
