class Admin::CommentsController < AdminController


	before_filter :authorize_admin

	def index 

		@comments = Comment.setup_and_search params

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
	      if @comment.update_attributes(comments_params)
	     	format.html { redirect_to edit_admin_comment_path(@comment), notice: 'Comment was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def bulk_update

		func = Comment.bulk_update params

		respond_to do |format|
	      format.html { redirect_to admin_comments_path, notice: "Comments were successfully #{func}" }
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

	def comments_params
		if !session[:admin_id].blank?
			params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :comment_approved, :parent_id, :is_spam, :commit, :submitted_on)
		end
	end

end