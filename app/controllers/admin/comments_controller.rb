class Admin::CommentsController < AdminController

	before_filter :authorize_admin

	def index 
		@comments = Comment.where("comment_approved != 'S'").order('submitted_on desc')
		
		if params.has_key?(:search) && !params[:search].blank?
			@comments = Comment.where("(author like ? or email like ? or comment like ?) and comment_approved != 'S'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%").order('submitted_on desc')
		end

		if params.has_key?(:filter) && params[:filter] != 'filter'
			@comments = Comment.where(:comment_approved => params[:filter]).order('created_at desc')
		end


	end

	def edit

		@comment = Comment.find(params[:id])

	end

	def destroy
 		@comment = Comment.find(params[:id])
	    @comment.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: 'Comment has been successfully deleted.' }
	    end

	end

	def update
	    @comment = Comment.find(params[:id])
	    respond_to do |format|
	      if @comment.update_attributes(params[:comment])
	     	format.html { redirect_to edit_admin_comment_path(@comment), notice: 'Comment was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def bulk_update

		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "unapprove"
				bulk_update_unapprove params[:comments]
				respond_to do |format|
			      format.html { redirect_to admin_comments_path, notice: 'Comments were successfully unapproved' }
			    end
			when "approve"
				bulk_update_approve params[:comments]
				respond_to do |format|
			      format.html { redirect_to admin_comments_path, notice: 'Comments were successfully approved' }
			    end
			when "mark_as_spam"
				bulk_update_mark_as_spam params[:comments]
				respond_to do |format|
			      format.html { redirect_to admin_comments_path, notice: 'Comments were successfully marked as spam' }
			    end
			when "destroy"
				bulk_update_destroy params[:comments]
				respond_to do |format|
			      format.html { redirect_to admin_comments_path, notice: 'Comments were successfully destroyed' }
			    end
		end

	end

	def mark_as_spam

		comment = Comment.find(params[:id])
		comment.comment_approved = "S"
		respond_to do |format|
			if comment.save
				format.html { redirect_to admin_comments_path, notice: 'Comment was successfully marked as spam' }
			else
				format.html { render action: "index" }
			end
		end
	end

	private 


	def bulk_update_unapprove comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "N"
			comment.save
		end
	end
	
	def bulk_update_approve comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "Y"
			comment.save
		end

	end
	
	def bulk_update_mark_as_spam comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.comment_approved = "S"
			comment.save
		end

	end
	
	def bulk_update_destroy comments
		comments.each do |val|
			comment = Comment.find(val)
			comment.destroy
		end
	end

end