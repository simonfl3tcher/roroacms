class CommentsController < ApplicationController

	include CommentsHelper

	def create
		comments_on = Setting.where(:setting_name => 'article_comments').first.setting
		comments_type = Setting.where(:setting_name => 'article_comment_type').first.setting

		if comments_on == 'Y' && comments_type = 'R'

			session[:return_to] ||= request.referer
			@comment = Comment.new(params[:comment])
			@comment.comment_approved = 'N'
			@comment.submitted_on = Time.now.to_s(:db)

			respond_to do |format|
			  if @comment.save
			  	Notifier.comment(@comment).deliver
			    format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: comments_success_message }
			  else

			  	html = ''

			  	if @comment.errors.any?
			  		html = comments_error_display(@comment)
				  end 

			    format.html { redirect_to "#{session[:return_to]}#commentsArea", notice: html.html_safe}

			  end
			end
		end
	end

end