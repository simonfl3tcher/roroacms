module ViewHelper

	def display_content
		render :inline => prep_content.html_safe
	end

	def display_title

		render :inline => @content.post_title

	end

	def display_date(format = nil)

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

	def get_the_content(post)

		render :inline => prep_content(post).html_safe

	end

	def get_the_title(post)

		render :inline => post.post_title

	end

	def get_the_excerpt(post, length = 300, omission = '...')

		render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length)


	end

	def get_the_date(post, format = nil)

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

	def get_the_permalink(post)

		article_url = Setting.get('articles_slug')
		site_url = Setting.get('site_url')

		if post.post_type == 'post'

			render :inline => "#{site_url}#{article_url}/#{post.post_slug}"
		
		else 

			render :inline => "#{site_url}#{post.post_slug}"

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

		comments_on = Setting.get('article_comments') 

		if comments_on == 'Y'

			type = Setting.get('article_comment_type')

			render(:template =>"theme/#{current_theme}/comments_form.html.erb", :layout => nil, :locals => { :type => type }).to_s

		else

			# do nothing 

		end

	end

	def return_comments(id = nil)
				

		if !id.nil?

			@comments = Comment.where(:post_id => id)

		else

			@comments = Comment.where(:post_id => @content.id, :comment_approved => 'Y')

		end

		return @comments

	end

	def display_comments_loop(id = nil)

		if !id.nil?

			@comments = Comment.where(:post_id => id)

		else

			@comments = Comment.where(:post_id => @content.id, :comment_approved => 'Y', :is_spam => 'N')

		end

		if @comments.count > 0 
			html = "<h3 id='comments-title'>#{@comments.count} responses to #{display_title}</h3>"
		end
		
		html = nested_comments return_comments.arrange(:order => 'created_at ASC')

		render :inline => html.html_safe

	end

	def display_author_information

		@admin = Admin.find_by_id(@content.admin_id)
		unless @admin.blank?
				html = "<div id='author-info'>
				<div id='author-description'>
					<h2>About #{@admin.first_name} #{@admin.last_name}</h2>
					<p>#{@admin.description}</p>						
				</div>
			</div>"

			render :inline => html.html_safe
		end

	end

	def site_url(str = nil)

		url = Setting.get('site_url')

		return "#{url}#{str}"
	end

	def get_search_form

		render :template => "theme/#{current_theme}/search_form.html.erb" rescue nil

	end

	def excerpt(content, length = 255, omission = '...')

		render :inline => truncate(content, :omission => omission, :length => length)

	end

	def get_banners(hash)

		return Banner.where(terms: {slug: hash[:key]}).includes(:terms).limit(hash[:limit]).order('sort_order')

	end

	def get_archives(type, blockbydate = nil)

		if type == 'Y'

			@posts = Post.where(:post_type => 'post', :post_status => 'Published', :disabled => 'N').uniq.pluck("EXTRACT(YEAR FROM post_date)")
			article_url = Setting.get('articles_slug') 
			category_url = Setting.get('category_slug')
				
			h = {}
			
			@posts.each do |f|
				h["#{article_url}/#{f}"] = f
			end

		elsif type == 'M'
			
			@posts = Post.where("(post_type = 'post' && post_status = 'Published' && disabled = 'N') && post_date <= CURDATE()").uniq.pluck("EXTRACT(YEAR FROM post_date)")
			article_url = Setting.get('articles_slug')
			category_url = Setting.get('category_slug')

			h = {}
			lp = {}
			mon = {}		
			@posts.each do |f|
				lp["#{f}"] = Post.where("YEAR(post_date) = #{f}  AND (post_type = 'post' && disabled = 'N' && post_status = 'Published' && post_date <= CURDATE())").uniq.pluck("EXTRACT(MONTH FROM post_date)")
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
	
	def get_categories(arr = nil)

		@terms = Term.where(term_anatomies: {taxonomy: 'category'}).includes(:term_anatomy)

			article_url = Setting.get('articles_slug')
			tag_url = Setting.get('category_slug')
			
			h = {}
			
			@terms.each do |f|
				h["#{article_url}/#{tag_url}/#{f.slug}"] = f.name
			end
			
			return li_loop h

	end
	
	def get_tag_cloud(type, arr = nil)

		@terms = Term.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy)

		if type == 'string'
			return @terms.all.collect {|u| u.name}.join ', '
		elsif type == 'list'

			article_url = Setting.get('articles_slug')
			tag_url = Setting.get('tag_slug')
			
			h = {}
			
			@terms.each do |f|
				h["#{article_url}/#{tag_url}/#{f.slug}"] = f.name
			end
			
			return li_loop h
		end

	end



	def nested_comments(messages)
	  
	  messages.map do |message, sub_messages|
	  	@comment = message
	    render('admin/partials/comment') + content_tag(:div, nested_comments(sub_messages), :class => "nested_comments")
	  end.join.html_safe

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


	def getdatenamebynumber(s)
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
            when 10 then "Oct"
            when 11 then "Nov" 
            when 12 then "Dec"
        end
	end

	def view_file_exists(f)
		return File.exists?("app/views/theme/#{current_theme}/template-#{f}.html.erb")
	end

	def is_page(i)

		@p = @content

		i = i.to_s

		if defined? @p.post_title
			if !@p.blank? 

				if i.nonnegative_float?
					if @p.id == i.to_i
						return true
					else
						return false
					end
				else 
					if @p.post_title.downcase == i.downcase
						return true
					else
						return false
					end

				end

			else

				return false

			end
		else

			return false
		end

	end

	def get_latest_article howmany = 1

		Post.where("post_type ='post' AND disabled = 'N' AND post_status = 'Published' AND post_date AND post_date <= CURDATE()").order('post_date DESC').limit(howmany)

	end

	def current_theme
		return Setting.find_by_setting_name('theme_folder')[:setting]
	end

	def theme_url(append)
		return "theme/#{current_theme}/#{append}"
	end
end