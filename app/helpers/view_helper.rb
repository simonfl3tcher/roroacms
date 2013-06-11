module ViewHelper

	def display_content
		render :inline => prep_content.html_safe
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

	def get_term_name
		segments = params[:slug].split('/')

		if !segments[2].blank?

			t =  Term.where(:slug => segments[2]).last

			return t.name

		else
			return nil
		end

	end

	def get_term_type 
		segments = params[:slug].split('/')

		if !segments[1].blank?

			term = TermAnatomy.where(:taxonomy => segments[1]).last

			return term.taxonomy

		else
			return nil
		end
	end

	def get_the_content post

		render :inline => post.post_content.html_safe

	end

	def get_the_title post

		render :inline => post.post_title

	end

	def get_the_excerpt post, length = 300, omission = '...'

		render :inline => truncate(strip_tags(post.post_content), :omission => omission, :length => length)


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

			render(:template =>"theme/comments_form.html.erb", :layout => nil, :locals => { :type => type }).to_s

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

		if @comments.count > 0 
			html = "<h3 id='comments-title'>#{@comments.count} responses to #{display_title}</h3>"
			html += "<ul class='commentsLoop'>"
		else 
			html = "<ul class='commentsLoop'>"
		end
		count = 1
		
		@comments.each do |comment|

			html += "<li class='comment' id='li-comment-#{count}'>
			<article id='comment-#{count}' class='comment'>
				<section class='comment-content comment'>
					<div class='comment-meta' data-author='#{comment.author}'><a href='http://#{comment.website}' target='_blank'>#{comment.author}</a> says:-</div>
					<span class='date'>#{comment.submitted_on.strftime("%b %e %Y, %l:%M %p")}</span>
					<p>#{comment.comment}</p>
				</section>
			</article>
			<div class='divide'></div>"
			#<a href='#' class='reply' data-parent='#{comment.id}'>Reply</a>"
		
	    html += "</li>"
			count = count + 1

		end

		html += '</ul>
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

	def display_author_information

		@admin = Admin.find(@content.admin_id)

		html = "<div id='author-info'>
		<div id='author-description'>
			<h2>About #{@admin.first_name} #{@admin.last_name}</h2>
			<p>#{@admin.description}</p>						
		</div>
	</div>"

	render :inline => html.html_safe

	end

	def site_url str = nil

		url = Setting.where(:setting_name => 'site_url').first.setting

		return "#{url}#{str}"
	end

	def get_search_form

		render :template => "theme/search_form.html.erb" rescue nil

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

	def get_archives type, blockbydate = nil

		if type == 'Y'

			@posts = Post.where(:post_type => 'post').uniq.pluck("EXTRACT(YEAR FROM post_date)")
			article_url = Setting.where(:setting_name => 'articles_slug').first.setting
			category_url = Setting.where(:setting_name => 'category_slug').first.setting
				
			h = {}
			
			@posts.each do |f|
				h["#{article_url}/#{f}"] = f
			end

		elsif type == 'M'
			
			@posts = Post.where(:post_type => 'post').uniq.pluck("EXTRACT(YEAR FROM post_date)")
			article_url = Setting.where(:setting_name => 'articles_slug').first.setting
			category_url = Setting.where(:setting_name => 'category_slug').first.setting

			h = {}
			lp = {}
			mon = {}		
			@posts.each do |f|
				lp["#{f}"] = Post.where("YEAR(post_date) = #{f} && post_type = 'post'").uniq.pluck("EXTRACT(MONTH FROM post_date)")
			end

			lp.each do |k, i|

				if blockbydate
					h["#{article_url}/#{k}"] = k
				end
				
				i.each do |nm|

					h["#{article_url}/#{k}/#{nm}"] = "#{getdatenamebynumber(nm)} - #{k}"

				end
			end

		end			
		return li_loop h

	end
	
	def get_categories arr = nil

		@terms = Term.where(term_anatomies: {taxonomy: 'category'}).includes(:term_anatomy)

		article_url = Setting.where(:setting_name => 'articles_slug').first.setting
		category_url = Setting.where(:setting_name => 'category_slug').first.setting
			
		h = {}
		
		@terms.each do |f|
			h["#{article_url}/#{category_url}/#{f.slug}"] = f.name
		end
		
		return li_loop h

	end
	
	def get_tag_cloud type, arr = nil

		@terms = Term.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy)

		if type == 'string'
			return @terms.all.collect {|u| u.name}.join ', '
		elsif type == 'list'

			article_url = Setting.where(:setting_name => 'articles_slug').first.setting
			tag_url = Setting.where(:setting_name => 'tag_slug').first.setting
			
			h = {}
			
			@terms.each do |f|
				h["#{article_url}/#{tag_url}/#{f.slug}"] = f.name
			end
			
			return li_loop h
		end

	end

	def the_archive_year
		segments = params[:slug].split('/')
		return segments[1]
	end

	def li_loop arr
		html = '<ul>'
		
		arr.each do |k, v|
			html += "<li><a href='#{site_url}#{k}'>#{v}</a></li>"
		end
		
		html += '</ul>'
		render :inline => html

	end

	def create_link arr

	end

	def getdatenamebynumber s
        case s
            when  1 then "Jan"
            when  2 then "Feb"
            when  3 then "Mar"
            when  4 then "Apr"
            when  5 then "May"
            when  6 then "Jun"
            when  7 then "Jul"
            when  8 then "Aug"
            when  9 then "Sep"
            when 10 then "Okt"
            when 11 then "Nov" 
            when 12 then "Dec"
        end
	end

	def view_file_exists f
		return File.exists?("app/views/theme/template-#{f}.html.erb")
	end

end