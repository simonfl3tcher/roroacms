class Comment < ActiveRecord::Base

	has_ancestry
	
	belongs_to :post

	validates :email, presence: true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create }

	validates :author, :comment, :presence => true

	before_create :set_defaults

	def self.setup_and_search params

		@comments = Comment.where("comment_approved != 'S'").order('submitted_on desc').page(params[:page]).per(Setting.get_pagination_limit)
		
		if params.has_key?(:search) && !params[:search].blank?
			@comments = Comment.where("(author like ? or email like ? or comment like ?) and comment_approved != 'S'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").order('submitted_on desc').page(params[:page]).per(Setting.get_pagination_limit)
		end

		if params.has_key?(:filter) && params[:filter] != 'filter'
			@comments = Comment.where(:comment_approved => params[:filter]).order('created_at desc').page(params[:page]).per(Setting.get_pagination_limit)
		end

		return @comments

	end

	def self.bulk_update params

		action = params[:to_do]
		action = action.gsub(' ', '_')

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

	end


	private 

	def set_defaults
		
		self.comment_approved = 'N'
		self.submitted_on = Time.now.to_s(:db) 

	end


	def self.bulk_update_unapprove comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "N"
			comment.save
		end
	end
	
	def self.bulk_update_approve comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "Y"
			comment.save
		end

	end
	
	def self.bulk_update_mark_as_spam comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "S"
			comment.save
		end

	end
	
	def self.bulk_update_destroy comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.destroy
		end
	end

  
end
