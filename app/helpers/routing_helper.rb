module RoutingHelper

	# renders the homepage that is set in the admin panel - unless it has search parameters,
	# it will render the search results page if it does have search parameters.
	# Params:
	# +params+:: all the current parameters. This is mainly used for the search results

	def route_index_page(params)

		if !params[:search].blank?

			# make the content avalible to the view
			gloalize Post.where("(post_title LIKE :p or post_slug LIKE :p2 or post_content LIKE :p3) and (post_type != 'autosave') AND (post_date <= NOW())", {:p => "%#{params[:search]}%", :p2 => "%#{params[:search]}%", :p3 => "%#{params[:search]}%"})
			
			# add breadcrumbs to the hash
			add_breadcrumb "Home", :root_path, :title => "Home"
			add_breadcrumb "Search", "/"

			render :template => "theme/#{current_theme}/search"

		else

			@content = Post.find(Setting.get('home_page'))
			# make the content avalible to the view
			gloalize @content
			render_template 'home'

		end


	end

	# changes the view to use the given template if it doesn't exist it will just use the page.html.erb
	# the template file is set in the admin panel on each individual page.
	# Params:
	# +name+:: the template file to use.

	def render_template(name)
		if !@content.post_template.blank?

			# check if the template file actually exists
			if File.exists?("app/views/theme/#{current_theme}/template-#{@content.post_template.downcase}.html.erb")

				render :template => "theme/#{current_theme}/template-#{@content.post_template.downcase}"

			else

				# check if a file with the given name exists
				if File.exists?("app/views/theme/#{current_theme}/#{name}.html.erb")	
					render :template => "theme/#{current_theme}/#{name}"
				else 
					# if not use the page.html.erb template which has to be included in the theme
					render :template => "theme/#{current_theme}/page.html.erb"
				end

			end

		else

			# check if a file with the given name exists
			if File.exists?("app/views/theme/#{current_theme}/#{name}.html.erb")
				render :template => "theme/#{current_theme}/#{name}"
			else
				# if not use the page.html.erb template which has to be included in the theme
				render :template => "theme/#{current_theme}/page.html.erb"
			end

		end	
	end

	# is used to find out if the requested is an article or a page
	# if it is a post it will prepend the url with the article url
	# Params:
	# +params+:: all the current parameters

	def show_url(params)

		post = Post.find(params[:id])
 		article_url = Setting.get('articles_slug')
 		url = ''

 		# if the post is an article. Prepend the url with the article url
 		if post.post_type == 'post'
 			url = "/#{article_url}/#{post.post_slug}"
 		end

 		url += "#{post.structured_url}"

 		url

	end


	# this is the function that gets the url and decides what to display 
	# with the given content. This is the main function for routing. Nearly every request runs through this function
	# Params:
	# +params+:: all the current parameters


	def route_dynamic_page(params)

		# split the url up into segments
		segments = params[:slug].split('/')

		# general variables
		url = params[:slug]
		article_url = Setting.get('articles_slug')
		category_url = Setting.get('category_slug')	
		tag_url = Setting.get('tag_slug')

		status = "(post_status = 'Published' AND post_date <= NOW() AND disabled = 'N')"

		# is it a article post or a page post
		if segments[0] == article_url

			if !segments[1].blank?
				if segments[1] == category_url || segments[1] == tag_url
					# render a category or tag page
					render_category segments, article_url, true, status
				elsif segments[1].nonnegative_float?
					# render the archive page
					render_archive segments, article_url
				else
					# otherwise render a single article page
					render_single segments, article_url, status
				end
			else
				# render the overall all the articles
				render_category segments, article_url, false, status
			end

		else
			# render a page
			render_page url, status
		end

	end

	# renders a standard post page
	# Params:
	# +url+:: the url that has been requested by the user
	# +status+:: is passed in from the above function - just sets the standard status this is needed for the admin


	def render_page(url, status)

		# get content - if the admin isn't logged in your add the extra status requirements
		if !session[:admin_id].blank?
			@content = Post.where(:post_type => 'page', :post_status => 'Published').find_by_structured_url("/#{url}")
		else
			@content = Post.where(status, :post_type => 'page', :post_status => 'Published').find_by_structured_url("/#{url}")
		end

		# add a breadcrumb for each of its parents by running through each segment
		url.split('/').each do |u|
			p = Post.where(:post_type => 'page').find_by_post_slug(u)
			if p
				add_breadcrumb "#{p.post_title.capitalize}", "#{p.structured_url}", :title => "Back to #{p.post_title.capitalize}"
			end
		end

		# if content if blank return a 404 
		render_404 and return if @content.nil?
		gloalize @content

		# if the content id is the same as the home page redirect to the home page do not render the content
		if Setting.get('home_page').to_i == @content.id.to_i
			redirect_to site_url
		else 
			render_template 'page'
		end

	end

	# renders a category, tag or view all articles page
	# Params:
	# +segments+:: an array of the url segments split via "/"
	# +article_url+:: is the url extension to show all articles  
	# +term+:: wether you want to display more than just the home article display i.e. /articles/category/gardening
	# +status+:: the general status of the posts

	def render_category(segments, article_url = nil, term = false, status)

		# do you want to filter the results down further than the top level
		if term
			
			if segments[2].blank?
				# if segment 2 is blank then you want to disply the top level article page
				redirect_to article_url
			else
				term = Term.where(:slug => segments[2]).first

				# do a search for the content
				gloalize Post.joins('LEFT JOIN term_relationships ON term_relationships.post_id = posts.id').where("(post_status = 'Published' AND post_date <= NOW() AND disabled = 'N') and term_relationships.term_id = ?", term).order('post_date DESC')
				# add the breadcrumbs
				add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
				add_breadcrumb "#{term.name.capitalize}", "/#{term.name}", :title => "Back to #{term.name.capitalize}"

				render :template => "theme/#{current_theme}/category"
			end

		else 

			# add article homepage
			add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
			gloalize Post.where("#{status} and post_type ='post' and disabled = 'N'").order('post_date DESC')
			render :template => "theme/#{current_theme}/category"

		end

	end

	# renders a single article page
	# Params:
	# +segments+:: an array of the url segments split via "/"
	# +article_url+:: is the url extension to show all articles  
	# +status+:: the general status of the posts

	def render_single(segments, article_url, status)

		# get content - if the admin isn't logged in your add the extra status requirements
		if !session[:admin_id].blank?
			@content = Post.where(:post_type => 'post').find_by_post_slug(segments[1])
		else
			@content = Post.where(status, :post_type => 'post', :disabled => 'N').find_by_post_slug(segments[1])
		end

		render_404 and return if @content.nil?
		gloalize @content

		# create a new comment object for the comment form
		@new_comment = Comment.new

		# add the necessary breadcrumbs
		add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
		add_breadcrumb "#{@content.post_title}", "/#{@content.post_name}", :title => "Back to #{@content.post_title}"

		# render the single template
		render_template 'single'

	end

	# renders a archive of articles - this could do with some refactoring
	# Params:
	# +segments+:: an array of the url segments split via "/"
	# +article_url+:: is the url extension to show all articles  

	def render_archive(segments, article_url)

		# add the breadcrumb
		add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"

		if !segments[3].blank?

			#  do seach for the content within the given parameters
			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND DAY(post_date) = ? AND post_date <= NOW())", segments[1], segments[2], segments[3]).order('post_date DESC')
			
			# add the breadcrumbs
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			add_breadcrumb "#{segments[2]}", "/#{article_url}/#{segments[1]}/#{segments[2]}", :title => "Back to #{segments[2]}"
			add_breadcrumb "#{segments[3]}", "/#{article_url}/#{segments[1]}/#{segments[2]}/#{segments[3]}", :title => "Back to #{segments[3]}"

			render :template => "theme/#{current_theme}/archive"

		elsif !segments[2].blank?
			
			#  do seach for the content within the given parameters
			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND post_date <= NOW())", segments[1], segments[2]).order('post_date DESC')
			# add the breadcrumbs
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			add_breadcrumb "#{segments[2]}", "/#{article_url}/#{segments[1]}/#{segments[2]}", :title => "Back to #{segments[2]}"

			render :template => "theme/#{current_theme}/archive"

		else
			#  do seach for the content within the given parameters
			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND post_date <= NOW())", segments[1]).order('post_date DESC')
			# add the breadcrumbs
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			
			render :template => "theme/#{current_theme}/archive"

		end

	end

end