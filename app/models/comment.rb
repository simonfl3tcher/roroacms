class Comment < ActiveRecord::Base

	has_ancestry

  belongs_to :post

  attr_accessible :post_id, :author, :email, :website, :comment, :comment_approved, :parent_id, :is_spam, :submitted_on

  validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  
  validates :author, :comment, :presence => true

  
end
