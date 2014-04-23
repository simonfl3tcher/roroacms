class CommentsController < ApplicationController

	# CommentsController is simply used for the blog comments form. On post it will save the data in the database for the admin to filter.
	
	include CommentsHelper

	def create
		# Check to see if comments are actually allowed, this can be switched on and off in the admin panel
		if comments_on
			
			session[:return_to] = request.referer
			@comment = Comment.new(comments_params)

			# strip any sort of html, we don't want javascrpt injection
			@comment.comment = @comment.comment.to_s.gsub(%r{</?[^>]+?>}, '').gsub(/<script.*?>[\s\S]*<\/script>/i, "")

			respond_to do |format|
			  if @comment.save
			  	Notifier.comment(@comment).deliver
			    format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: comments_success_message }
			  else

			    format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: comments_error_display(@comment).html_safe}

			  end
			end
		end
	end

	private

	# Strong parameters

	def comments_params
		params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :parent_id)
	end

end