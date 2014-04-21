class Admin::CommentsController < AdminController

	# list out all of the comments

	def index 
		@comments = Comment.setup_and_search params
	end

	# get and disply certain comment

	def edit
		@comment = Comment.find(params[:id])
	end

	# delete the comment

	def destroy
 		@comment = Comment.find(params[:id])
	    @comment.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: 'Comment has been successfully deleted.' }
	    end

	end

	# update the comment. You are able to update everything about the comment as an admin

	def update
	    @comment = Comment.find(params[:id])
	    atts = comments_params
	    #  remove any html from the comment as we do not need it and it can be detrimental to the system
	    atts[:comment] = atts[:comment].to_s.gsub(%r{</?[^>]+?>}, '')

	    respond_to do |format|

	      if @comment.update_attributes(atts)
	     	format.html { redirect_to edit_admin_comment_path(@comment), notice: 'Comment was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end

	    end
	end

	# bulk_update function takes all of the checked options and updates them with the given option selected. The options for the bulk update in comments area are
	# - Unapprove
	# - Approve
	# - Mark as Spam
	# - Destroy

	def bulk_update
		# This is what makes the update
		func = Comment.bulk_update params

		respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: "Comments were successfully #{func}" }
	    end

	end

	# mark_as_spam function is a button on the ui and so need its own function. The function simply marks the comment as spam against the record in the database. 
	# the record is then not visable unless you explicity tell the system that you want to see spam records.

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

	# Strong parameter

	def comments_params
		if !session[:admin_id].blank?
			params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :comment_approved, :parent_id, :is_spam, :commit, :submitted_on)
		end
	end

end