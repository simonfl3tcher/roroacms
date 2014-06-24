class Comment < ActiveRecord::Base

	has_ancestry
	
	# relations and validations

	belongs_to :post
	validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }
	validates :author, :comment, :presence => true

	# set defaults before comment gets added to the database 

	before_create :set_defaults

	# The bootstrap for the bulk update function. It takes in the call
	# and decides what function to call in order to get the correct output

	def self.bulk_update(params)

		action = params[:to_do]
		action = action.gsub(' ', '_')

		if !params[:comments].blank?

			case action.downcase 
				when "unapprove"
					bulk_update_unapprove params[:comments]
					return 'unapproved'
				when "approve"
					bulk_update_approve params[:comments]
					return 'approved'
				when "mark_as_spam"
					bulk_update_mark_as_spam params[:comments]
					return 'marked as spam'
				when "destroy"
					bulk_update_destroy params[:comments]
					return 'destroyed'
			end
		else
			return 'ntd'
		end

	end


	private 

	# set default values of the record before adding to the database

	def set_defaults
		self.comment_approved = 'N'
		self.submitted_on = Time.now.to_s(:db) 
	end

	# bulk unapprove given comments

	def self.bulk_update_unapprove(comments)
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "N"
			comment.save
		end
	end

	# bulk approve given comments
	
	def self.bulk_update_approve(comments)
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "Y"
			comment.save
		end
	end

	# bulk mark as spam for given comments
	
	def self.bulk_update_mark_as_spam(comments)
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "S"
			comment.is_spam = "Y"
			comment.save
		end
	end

	# bulk delete given comments
	
	def self.bulk_update_destroy(comments)
		comments.each do |val|
			comment = Comment.find(val)
			comment.destroy
		end
	end
  
end
