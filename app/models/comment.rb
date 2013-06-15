class Comment < ActiveRecord::Base

	has_ancestry

	belongs_to :post

	validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

	validates :author, :comment, :presence => true

	before_create :set_defaults
	
	def set_defaults
		
		self.comment_approved = 'N'
		self.submitted_on = Time.now.to_s(:db) 

	end

  
end
