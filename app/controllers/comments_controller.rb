class CommentsController < ApplicationController

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
			    format.html { redirect_to session[:return_to], notice: 'Comment was successfully created. Awaiting Review' }
			  else

			  	html = ''

			  	if @comment.errors.any?
					html = "<div id='error_explanation'>
					<h2>Invalid:</h2><ul>"
					@comment.errors.full_messages.each do |msg| 
					html += "<li>#{msg}</li>"
					end
					html += "</ul>
					</div>"
				  end 

				  # <%= pluralize(@page.errors.count, "error") %> errors:

			    format.html { redirect_to session[:return_to], notice: html.html_safe}
			    # format.json { render json: @user.errors, status: :unprocessable_entity }
			  end
			end
		end
	end

end