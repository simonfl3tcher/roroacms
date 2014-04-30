module ViewHelper

	# The view helper contains all of the functions that the views
	# will use in order to display the contents of either the content
	# or format other data


	# display the content of the globalized @content record

	def display_content
		render :inline => prep_content.html_safe
	end


	# display the content of the globalized @content record

	def display_title
		render :inline => @content.post_title
	end


	# display the date of the globalized @content record
	# Params:
	# +format+:: the date format that you want the date to be provided in

	def display_date(format = "%d-%m-%Y")
		render :inline => @content.post_date.strftime(format)
	end


	# display the taxonomy name from the url

	def get_term_name

		segments = params[:slug].split('/')

		# get the taxonomy name and search the database for the record with this as its slug
		if !segments[2].blank?
			t =  Term.where(:slug => segments[2]).last
			return t.name
		else
			return nil
		end

	end


	# return what type of taxonomy it is either - category or tag

	def get_term_type 
		
		segments = params[:slug].split('/')

		if !segments[1].blank?
			term = TermAnatomy.where(:taxonomy => segments[1]).last
			return term.taxonomy
		else
			return nil
		end

	end


	# display the content of the given post via the post parameter
	# Params:
	# +post+:: post record that you want to return the content of

	def get_the_content(post)
		render :inline => prep_content(post).html_safe
	end


	# display the title of the given post via the post parameter
	# Params:
	# +post+:: post record that you want to return the title of

	def get_the_title(post)
		render :inline => post.post_title
	end


	# checks to see if it is the home page

	def is_homepage?
		return false if (!defined?(@content.length).blank? || @content.blank?)
		@content.id == Setting.get('home_page').to_i	? true : false
	end	


	# is a category page
	# Params:
	# +check+:: check wether it is a certain category or not by name or id

	def is_category?(check = nil)
		segments = params[:slug].split('/')
		if check.blank?
			Setting.get('category_slug') == segments[1] ? true : false
		else 
			(Setting.get('category_slug') == segments[1] && (Term.where(slug: segments[2]).first.name == check || Term.where(slug: segments[2]).first.id == check) ) ? true : false
		end
	end

	# is a single archive page
	# Params:
	# +check+:: check wether it is a certain category or not by name or id

	def is_article?(check = nil)
		segments = params[:slug].split('/')
		if check.blank?
			Setting.get('articles_slug') == segments[0] ? true : false
		else 
			if !defined?(@content.size).blank?
				return false
			end
			(Setting.get('articles_slug') == segments[0] && (@content.post_title == check || @content.id == check) ) ? true : false
		end
	end

	def is_tag?(check = nil)
		segments = params[:slug].split('/')
		if check.blank?
			Setting.get('tag_slug') == segments[1] ? true : false
		else 
			(Setting.get('tag_slug') == segments[1] && (Term.where(slug: segments[2]).first.name == check || Term.where(slug: segments[2]).first.id == check) ) ? true : false
		end
	end


	# is archive page
	# Params:
	# +check+:: check wether it is a certain carchive or not by name or id

	def is_archive?
		get_type_by_url == 'AR' ? true : false
	end


	# is a overall category page
	# Params:
	# +check+:: can be either name or id of the post 

	def is_articles_home?
		get_type_by_url == 'C' ? true : false
	end


	# Check to see if given id or string is the current content record
	# Params:
	# +check+:: can be either name or id of the post 

	def is_page?(check)

		@p = @content

		check = check.to_s

		if defined? @p.post_title
			if !@p.blank? 
				if check.nonnegative_float?
					if @p.id == check.to_i
						return true
					else
						return false
					end
				else 
					if @p.post_title.downcase == check.downcase
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

	# A short extract from the post content
	# Params:
	# +post+:: post record that you want to return the title of
	# +length+:: length of the string in characters  
	# +omission+:: something to represent the omission of the content

	def get_the_excerpt(post, length = 300, omission = '...')
		render :inline => truncate(post.post_content.to_s.gsub(/<[^>]*>/ui,'').html_safe, :omission => omission, :length => length)
	end


	# The same as the above however you can provide any content to this function

	def excerpt(content, length = 255, omission = '...')
		render :inline => truncate(content, :omission => omission, :length => length)
	end


	# display the date of the given post via the post parameter
	# Params:
	# +format+:: the date format that you want the date to be provided in

	def get_the_date(post, format = "%d-%m-%Y")
		render :inline => post.post_date.strftime(format)
	end


	# Easy to understand function for getting the category data

	def get_category_data 
		@content
	end


	# Easy to understand function for getting the archive data

	def get_archive_date
		@content
	end


	# Gets the link to the post
	# Params:
	# +post+:: post record that you want to return the link of

	def get_the_permalink(post)

		post = Post.find(post) if post.is_a? Integer 

		article_url = Setting.get('articles_slug')
		site_url = Setting.get('site_url')

		if post.post_type == 'post'
			render :inline => "#{site_url}#{article_url}/#{post.post_slug}"
		else 
			render :inline => "#{site_url}#{post.post_slug}"
		end

	end


	# Returns generic notifications if the flash data exists

	def get_notifications
		if flash[:notice]
	    	html = "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Success!</strong> #{flash[:notice]}</div>"
	    	render :inline => html.html_safe
	    elsif flash[:error]
	    	html = "<div class='alert alert-danger'><button type='button' class='close' data-dismiss='alert'>x</button><strong>Error!</strong> #{flash[:error]}</div>"
	    	render :inline => html.html_safe
	    end
	end


	# gets the comment form from the theme folder and displays it.

	def display_comments_form

		if Setting.get('article_comments') == 'Y'
			type = Setting.get('article_comment_type')
			render(:template =>"theme/#{current_theme}/comments_form." + get_theme_ext , :layout => nil, :locals => { :type => type }).to_s
		end

	end


	# Gets the comments of the given post
	# Params:
	# +post_id+:: id of the post that you want to get comments for

	def return_comments(post_id = nil)
				
		if !post_id.nil?
			comments = Comment.where(:post_id => post_id)
		else
			comments = Comment.where(:post_id => @content.id, :comment_approved => 'Y')
		end

		comments

	end


	# Returns a nested list of the comments
	# Params:
	# +post_id+:: id of the post that you want to get comments for

	def display_comments_loop(post_id = nil)

		# get the comments by the post id or the globalized @content record
		if !post_id.nil?
			comments = Comment.where(:post_id => post_id)
		else
			comments = Comment.where(:post_id => @content.id, :comment_approved => 'Y', :is_spam => 'N')
		end

		if comments.count > 0 
			html = "<h3 id='comments-title'>#{comments.count} responses to #{display_title}</h3>"
		end
		
		html = nested_comments return_comments.arrange(:order => 'created_at ASC')

		render :inline => html.html_safe

	end


	# Return the author information of the articles

	def display_author_information(raw = false)

		@admin = Admin.find_by_id(@content.admin_id)
		if raw 
			return @admin
		else 
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

	end


	# Returns the url of site appended with the given string
	# Params:
	# +str+:: the string to append onto the end of the site url

	def site_url(str = nil)
		url = Setting.get('site_url')
		return "#{url}#{str}"
	end


	# Easy to understand function for getting the search form. 
	# this is created and displayed from the theme.

	def get_search_form
		render :template => "theme/#{current_theme}/search_form." + get_theme_ext  rescue nil
	end


	# Returns a hash of the records with the banner category key of the given value
	# Params:
	# +hash+:: a hash of both the key of the category and the limit to the amount of banners you want to return

	def get_banners(hash)
		Banner.where(terms: {slug: hash[:key]}).includes(:terms).limit(hash[:limit]).order('sort_order')
	end


	# Returns a list of the archives
	# Params:
	# +type+:: has to be either Y (year) or M (month)

	def get_archives(type, blockbydate = nil)

		# if year 
		if type == 'Y'

			# variables and data
			@posts = Post.where(:post_type => 'post', :post_status => 'Published', :disabled => 'N').uniq.pluck("EXTRACT(YEAR FROM post_date)")
			article_url = Setting.get('articles_slug') 
			category_url = Setting.get('category_slug')
				
			h = {}
			
			@posts.each do |f|
				h["#{article_url}/#{f}"] = f
			end

		# if month
		elsif type == 'M'
			
			# variables and data
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
					h["#{article_url}/#{k}/#{nm}"] = "#{get_date_name_by_number(nm)} - #{k}"
				end

			end

		end			
		
		li_loop(h)

	end


	# Returns a list of the categories
	
	def get_categories

		# variables and data
		@terms = Term.where(term_anatomies: {taxonomy: 'category'}).includes(:term_anatomy)
		article_url = Setting.get('articles_slug')
		tag_url = Setting.get('category_slug')
		
		h = {}
		
		@terms.each do |f|
			h["#{article_url}/#{tag_url}/#{f.slug}"] = f.name
		end
		
		li_loop(h)

	end


	# Returns either a list or a tag cloud of the tags - this shows ALL of the tags
	# Params:
	# +type+:: string or list style 
	
	def get_tag_cloud(type)

		@terms = Term.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy)
		article_url = Setting.get('articles_slug')
		tag_url = Setting.get('tag_slug')

		if type == 'string'

			# if you want a tag cloud
			return @terms.all.map do |u| 
				url = article_url + '/' + tag_url + '/' + u.slug
				"<a href='#{site_url(url)}'>" + u.name + "</a>"
			end.join(', ').html_safe

		elsif type == 'list'

			# if you want a list style
			h = {}
			@terms.each do |f|
				h["#{article_url}/#{tag_url}/#{f.slug}"] = f.name
			end
			return li_loop(h)

		end

	end

	def tag_cloud(id = nil)

		article_url = Setting.get('articles_slug')
		tag_url = Setting.get('tag_slug')

		if id.blank?
			terms = @content.terms.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy)
		else
			terms = Post.find(id).terms.where(term_anatomies: {taxonomy: 'tag'}).includes(:term_anatomy) 
		end

		return terms.all.map do |u| 
				url = article_url + '/' + tag_url + '/' + u.slug
				"<a href='#{site_url(url)}'>" + u.name + "</a>"
			end.join(', ').html_safe
	end

	# get posts with the ID of the given string '1,2,4'
	# Params:
	# +ids+:: an array of ids that you want to get the post object of

	def get_posts ids 
		Post.where(:id => ids)
	end

	# get sub pages of a post
	# Params:
	# +parent_id+:: ID of the parent post that you want to get the sub pages for

	def get_subpages parent_id = nil, limit = nil, orderby = 'post_title'
		posts = Post.where(:parent_id => parent_id.blank? ? @content.id : parent_id).order("post_title")
		if !limit.blank?
			posts = posts.limit(1)
		end
		posts
	end

	# Returns the html for the comments tree of a post
	# Params:
	# +messages+:: all of the messages for the post

	def nested_comments(messages)
		messages.map do |message, sub_messages|
			@comment = message
			render('admin/partials/comment') + content_tag(:div, nested_comments(sub_messages), :class => "nested_comments")
		end.join.html_safe
	end


	# Returns the year that you are viewing via the segmentation

	def the_archive_year
		str = ''
		segments = params[:slug].split('/')
		str = (get_date_name_by_number(segments[2].to_i) + ' ') if !segments[2].blank?
		str += segments[1]
	end


	# Returns a list of the given data
	# Params:
	# +arr+:: array that you want to list through to create the list

	def li_loop arr
		
		html = '<ul>'
		arr.each do |k, v|
			html += "<li><a href='#{site_url}#{k}'>#{v}</a></li>"
		end
		html += '</ul>'
		
		render :inline => html

	end


	# Returns a sub string of the month name 
	# Params:
	# +s+:: integer of the month 

	def get_date_name_by_number(s)
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


	# Check to see if the template file actually exists
	# Params:
	# +name+:: template name

	def view_file_exists?(name)
		File.exists?("app/views/theme/#{current_theme}/template-#{name}." + get_theme_ext )
	end


	# returns the lastest article. By default this is 1 but you can get more than one if you want.
	# Params:
	# +how_many+:: how many records you want to return

	def get_latest_article(how_many = 1)
		Post.where("post_type ='post' AND disabled = 'N' AND post_status = 'Published' AND post_date AND post_date <= CURDATE()").order('post_date DESC').limit(how_many)
	end


	# get current theme 

	def current_theme
		Setting.get('theme_folder')
	end


	# returns a full url to the file that you want to render from the theme file. 
	# example usage would be: <%= render theme_url 'sidebar' %>
	# Params:
	# +append+:: the name of the file that you want to render

	def theme_url(append)
		"theme/#{current_theme}/#{append}"
	end

	# displays the header.  + get_theme_ext template in the theme if the file exists 

	def display_header 
		render :template => "/theme/#{current_theme}/header." + get_theme_ext  if File.exists?("app/views/theme/#{current_theme}/header." + get_theme_ext )
	end

	# displays the header.  + get_theme_ext template in the theme if the file exists 

	def display_footer
		render :template => "theme/#{current_theme}/footer." + get_theme_ext  if File.exists?("app/views/theme/#{current_theme}/footer." + get_theme_ext )
	end
	
end