module RoutingHelper

	def route_index_page(params)

		if !params[:search].blank?
			gloalize Post.where("(post_title LIKE :p or post_slug LIKE :p2 or post_content LIKE :p3) and (post_type != 'autosave')", {:p => "%#{params[:search]}%", :p2 => "%#{params[:search]}%", :p3 => "%#{params[:search]}%"})
			add_breadcrumb "Home", :root_path, :title => "Home"
			add_breadcrumb "Search", "/"
			render :template => "theme/#{current_theme}/search"

		else

			home_id = Setting.get('home_page')	
			@content = Post.find(home_id)
			gloalize @content
			render_template 'home'
		end


	end

	def render_template(default)



		if !@content.post_template.blank?

			if File.exists?("app/views/theme/#{current_theme}/template-#{@content.post_template.downcase}.html.erb")

				render :template => "theme/#{current_theme}/template-#{@content.post_template.downcase}"

			else

				if File.exists?("app/views/theme/#{current_theme}/#{default}.html.erb")	

					render :template => "theme/#{current_theme}/#{default}"
				else 

					render :template => "theme/#{current_theme}/page.html.erb"

				end

			end

		else

			if File.exists?("app/views/theme/#{current_theme}/#{default}.html.erb")

				render :template => "theme/#{current_theme}/#{default}"

			else

				render :template => "theme/#{current_theme}/page.html.erb"

			end

		end	

	end

	def show_url(params)

		post = Post.find(params[:id])
 		article_url = Setting.get('articles_slug')
 		@url = ''
 		
 		if post.post_type == 'post'
 			@url = "/#{article_url}/#{post.post_slug}"
 		end

 		@url += "#{post.structured_url}"

 		return @url

	end


	def route_dynamic_page(params)

		segments = params[:slug].split('/')
		url = params[:slug]
		article_url = Setting.get('articles_slug')
		category_url = Setting.get('category_slug')	
		tag_url = Setting.get('tag_slug')

		if !session[:admin_id].blank?

			status = "(post_status = 'Published' AND post_date <= NOW() AND disabled = 'N')"

		else

			status = "(post_status = 'Published' AND post_date <= NOW() AND disabled = 'N')"

		end

		if segments[0] == article_url

			if !segments[1].blank?
				if segments[1] == category_url
					
					render_category segments, article_url, true, status

				elsif segments[1] == tag_url

					render_category segments, article_url, true, status

				elsif segments[1].nonnegative_float?

					render_archive segments, article_url

				else

					render_single segments, article_url, status

				end

			else
				render_category segments, article_url, status
			end

		else
			render_page url, status
		end

	end


	def render_page(url, status)

		home_id = Setting.get('home_page')	
		if !session[:admin_id].blank?
					
			@content = Post.where(:post_type => 'page').find_by_structured_url("/#{url}")

		else

			@content = Post.where(status, :post_type => 'page').find_by_structured_url("/#{url}")

		end

		

		url = url.split('/')

		url.each do |u|
			p = Post.where(:post_type => 'page').find_by_post_slug(u)
			if p
				add_breadcrumb "#{p.post_title.capitalize}", "#{p.structured_url}", :title => "Back to #{p.post_title.capitalize}"
			end
		end

		gloalize @content
		if @content.nil?
			add_breadcrumb "404", "#", :title => "Back to 404"
			render_404 and return 
		end


		if home_id.to_i == @content.id.to_i
			redirect_to site_url
		else 
			render_template 'page'
		end

	end

	def render_category(segments, article_url = nil, term = false, status)

		if term

			if segments[2].blank?
				
				redirect_to article_url

			else
				term = Term.where(:slug => segments[2]).first
				gloalize Post.where(terms: {id: term}, :post_type => 'post', :post_status => 'Published', :disabled => 'N').order('post_date DESC').includes(:terms)
				add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
				add_breadcrumb "#{term.name.capitalize}", "/#{term.name}", :title => "Back to #{term.name.capitalize}"
				render :template => "theme/#{current_theme}/category"
			end

		else 
			add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
			gloalize Post.where("#{status} and post_type ='post' and disabled = 'N'").order('post_date DESC')
			render :template => "theme/#{current_theme}/category"
		end
	end

	def render_single(segments, article_url, status)

		if !session[:admin_id].blank?
							
			@content = Post.where(:post_type => 'post', ).find_by_post_slug(segments[1])

		else

			@content = Post.where(status, :post_type => 'post', :disabled => 'N').find_by_post_slug(segments[1])

		end



		gloalize @content
		render_404 and return if @content.nil?
		@new_comment = Comment.new
		add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"
		add_breadcrumb "#{@content.post_title}", "/#{@content.post_name}", :title => "Back to #{@content.post_title}"
		render_template 'single'

	end

	def render_archive(segments, article_url)

		add_breadcrumb "#{article_url.capitalize}", "/#{article_url}", :title => "Back to #{article_url.capitalize}"

		if !segments[3].blank?

			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND DAY(post_date) = ? AND post_date <= NOW())", segments[1], segments[2], segments[3]).order('post_date DESC')
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			add_breadcrumb "#{segments[2]}", "/#{article_url}/#{segments[1]}/#{segments[2]}", :title => "Back to #{segments[2]}"
			add_breadcrumb "#{segments[3]}", "/#{article_url}/#{segments[1]}/#{segments[2]}/#{segments[3]}", :title => "Back to #{segments[3]}"
			render :template => "theme/#{current_theme}/archive"

		elsif !segments[2].blank?

			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND post_date <= NOW())", segments[1], segments[2]).order('post_date DESC')
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			add_breadcrumb "#{segments[2]}", "/#{article_url}/#{segments[1]}/#{segments[2]}", :title => "Back to #{segments[2]}"
			render :template => "theme/#{current_theme}/archive"

		else

			gloalize Post.where("(disabled = 'N' AND post_status = 'Published') AND post_type = 'Post' AND (YEAR(post_date) = ? AND post_date <= NOW())", segments[1]).order('post_date DESC')
			add_breadcrumb "#{segments[1]}", "/#{article_url}/#{segments[1]}", :title => "Back to #{segments[1]}"
			render :template => "theme/#{current_theme}/archive"

		end

	end

end