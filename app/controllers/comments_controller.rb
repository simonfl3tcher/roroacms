class CommentsController < ApplicationController

	include CommentsHelper

	def create

		if comments_on
			
			session[:return_to] ||= request.referer
			@comment = Comment.new(params[:comment])

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

	def comments_params
		params.require(:comment).permit(:post_id, :author, :email, :website, :comment)
	end

end