class Comment < ActiveRecord::Base
  belongs_to :post

  attr_accessible :post_id, :author, :email, :website, :comment, :comment_approved, :comment_parent, :is_spam, :submitted_on

  validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
  
  validates :author, :comment, :presence => true

  
end
