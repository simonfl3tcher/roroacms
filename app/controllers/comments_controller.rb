class CommentsController < ApplicationController

	include CommentsHelper

	def create

		if comments_on
			
			session[:return_to] = request.referer
			@comment = Comment.new(comments_params)
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

	def update 

		if comments_on
			
			session[:return_to] = request.referer
			@comment = Comment.new(comments_params)

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
		params.require(:comment).permit(:post_id, :author, :email, :website, :comment, :parent_id)
	end

end