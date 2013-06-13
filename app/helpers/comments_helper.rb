module CommentsHelper

	def comments_error_display content = nil

		html = "<div id='error_explanation'>
		<h2>Invalid:</h2><ul>"
		content.errors.full_messages.each do |msg| 
		html += "<li>#{msg}</li>"
		end
		html += "</ul>
		</div>"

		return html

	end

	def comments_success_message

		html = '<div class="success">Comment was successfully posted. Awaiting Review</div>'.html_safe

	end

end