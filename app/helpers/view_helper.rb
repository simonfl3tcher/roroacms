module ViewHelper

	def display_content
		render :inline => @content.post_content.html_safe
	end

	def display_title

		render :inline => @content.post_title

	end

	def display_date format = nil

		if format

			render :inline => @content.post_date.strftime(format)

		else

			render :inline => @content.post_date.strftime("%d-%m-%Y")

		end

	end

	def get_the_content post

		render :inline => post.post_content.html_safe

	end

	def get_the_title post

		render :inline => post.post_title

	end

	def get_the_excerpt post, length = 15, omission = '...'

		render :inline => truncate(post.post_content, :omission => omission, :length => length)


	end

	def get_the_date post, format = nil

		if format

			render :inline => post.post_date.strftime(format)

		else

			render :inline => post.post_date.strftime("%d-%m-%Y")

		end

	end

	def get_category_data 

		return @content

	end

	def get_archive_date

		return @content

	end

	def get_the_permalink post

		article_url = Setting.where(:setting_name => 'articles_slug').first.setting

		if post.post_type == 'post'

			render :inline => "http://localhost:3000/#{article_url}/#{post.post_slug}"
		
		else 

			render :inline => "http://localhost:3000/#{post.post_slug}"

		end

	end

	def get_archive_caption

		render :inline => 'Archive area'

	end

	def get_notifications

		if flash[:notice]
	    	html = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Success!</strong> #{flash[:notice]}</div>"
	    	render :inline => html.html_safe
	    elsif flash[:error]
	    	html = "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Error!</strong> #{flash[:error]}</div>"
	    	render :inline => html.html_safe
	    end
	end

	def display_comments_form

		comments_on = Setting.where(:setting_name => 'article_comments').first.setting

		if comments_on == 'Y'

			type = Setting.where(:setting_name => 'article_comment_type').first.setting

			render(:template =>"pages/comments_form.html.erb", :layout => nil, :locals => { :type => type }).to_s

		else

			# do nothing 

		end

	end

	def display_comments_loop id = nil

		if !id.nil?

			@comments = Comment.where(:post_id => id)

		else

			@comments = Comment.where(:post_id => @content.id, :comment_approved => 'Y')

		end


		html = '<ol>'
		count = 1
		
		@comments.each do |comment|

			html += "<li class='comment' id='li-comment-#{count}'>
		<article id='comment-#{count}' class='comment'>
			<section class='comment-content comment'>
				<p>#{comment.comment}</p>
				<div class='comment-meta' data-author='#{comment.author}'><a href='http://#{comment.website}' target='_blank'>#{comment.author}</a></div>
			</section></article>"
			#<a href='#' class='reply' data-parent='#{comment.id}'>Reply</a>"
		
	    html += "</li>"
			count = count + 1

		end

		html += '</ol>
		<script type="text/javascript">
			$(document).ready(function(){
				$(\'.reply\').click(function(){
					$("#comment_comment_parent").val($(this).attr("data-parent"));
					$("#replyToTitle").html("Reply To:- " + $(this).parent().find(".comment-meta").attr("data-author"));
			        $(\'html,body\').animate({
			            scrollTop: $("fieldset.commentForm").offset().top
			        }, \'slow\');
				})
			});

		</script>'

		render :inline => html.html_safe

	end

	def site_url

		return Setting.where(:setting_name => 'site_url').first.setting
	end

	def excerpt content, length = 255, omission = '...'

		render :inline => truncate(content, :omission => omission, :length => length)
	end

	def nested_messages(messages)
	  messages.map do |message, sub_messages|
	    render(message) + content_tag(:div, nested_messages(sub_messages), :class => "nested_messages")
	  end.join.html_safe
	end

	def get_banners hash
		return Banner.where(terms: {slug: hash[:key]}).includes(:terms).limit(hash[:limit]).order('sort_order')
	end

end