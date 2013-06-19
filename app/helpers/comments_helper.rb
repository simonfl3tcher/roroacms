module CommentsHelper

	def comments_error_display content = nil

		html = ''

		if content.errors.any?
			

			html = "<div id='error_explanation'>
			<h2>Invalid:</h2><ul>"
			content.errors.full_messages.each do |msg| 
			html += "<li>#{msg}</li>"
			end
			html += "</ul>
			</div>"
		
		end 

		return html

	end

	def comments_success_message

		html = '<div class="success">Comment was successfully posted. Awaiting Review</div>'.html_safe

	end

	def comments_on
		comments_on = Setting.where(:setting_name => 'article_comments').first.setting
		comments_type = Setting.where(:setting_name => 'article_comment_type').first.setting

		if comments_on == 'Y' && comments_type = 'R'
			return true
		else 
			return false
		end

	end

end