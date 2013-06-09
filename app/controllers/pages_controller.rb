class PagesController < ApplicationController

	def index

		if !params[:search].blank?
			gloalize Post.where("post_title LIKE :p or post_slug LIKE :p2 or post_content LIKE :p3 and post_type != 'autosave'", {:p => "%#{params[:search]}%", :p2 => "%#{params[:search]}%", :p3 => "%#{params[:search]}%"})
			render :template => "pages/search"

		else

			home_id = Setting.where(:setting_name => 'home_page').first.setting
			@content = Post.find(home_id)
			gloalize @content

			if !@content.post_template.blank?

				if File.exists?("app/views/pages/template-#{@content.post_template.downcase}.html.erb")

					render :template => "pages/template-#{@content.post_template.downcase}"

				else

					render :template => "pages/home"

				end

			else

				render :template => "pages/home"

			end			
		end

 	end

 	def show
 		post = Post.find(params[:id])
 		article_url = Setting.where(:setting_name => 'articles_slug').first.setting

 		@url = ''
 		
 		if post.post_type == 'post'
 			@url = "/#{article_url}"
 		end

 		@url += "/#{post.post_slug}"


 		redirect_to @url

 	end

	def dynamic_page
		
		segments = params[:slug].split('/')
		article_url = Setting.where(:setting_name => 'articles_slug').first.setting
		category_url = Setting.where(:setting_name => 'category_slug').first.setting
		tag_url = Setting.where(:setting_name => 'tag_slug').first.setting

		if !session[:admin_id].blank?

			status = "(post_status = 'Published')"

		else

			status = "(post_status = 'Published' AND post_date <= DATE(NOW()))"

		end

		if segments[0] == article_url

			if !segments[1].blank?

				if segments[1] == category_url

					if segments[2].blank?
						redirect_to article_url

					else

						term = Term.where(:slug => segments[2])
						gloalize Post.where(terms: {id: term}, :post_type => 'post', :post_status => 'Published').includes(:terms)
						render :template => "pages/category"


					end

				elsif segments[1] == tag_url


					if segments[2].blank?
						redirect_to article_url

					else

						term = Term.where(:slug => segments[2])
						gloalize Post.where(terms: {id: term}, :post_type => 'post', :post_status => 'Published').includes(:terms)
						render :template => "pages/category"


					end

				elsif segments[1].nonnegative_float?

					if !segments[3].blank?

						gloalize Post.where("post_status = 'Published' AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND DAY(post_date) = ?)", segments[1], segments[2], segments[3])
						render :template => "pages/archive"

					elsif !segments[2].blank?

						gloalize Post.where("post_status = 'Published' AND post_type = 'Post' AND (YEAR(post_date) = ? AND MONTH(post_date) = ?)", segments[1], segments[2])
						render :template => "pages/archive"

					else

						gloalize Post.where("post_status = 'Published' AND post_type = 'Post' AND (YEAR(post_date) = ?)", segments[1])
						render :template => "pages/archive"

					end



				else

					if !session[:admin_id].blank?
							
						@content = Post.where(:post_type => 'post').find_by_post_slug(segments[1])

					else

						@content = Post.where(status, :post_type => 'post').find_by_post_slug(segments[1])

					end

					gloalize @content
					render_404 and return if @content.nil?
					@comment = Comment.new
					
					if !@content.post_template.blank?

						if File.exists?("app/views/pages/template-#{@content.post_template.downcase}.html.erb")	

							render :template => "pages/template-#{@content.post_template.downcase}"

						else

							render :template => "pages/single"

						end

					else

						render :template => "pages/single"

					end

				end

			else
				gloalize Post.where("#{status} and post_type ='post'")
				render :template => "pages/category"
			end

		else
			if !session[:admin_id].blank?
					
				@content = Post.where(:post_type => 'page').find_by_post_slug(segments[0])

			else

				@content = Post.where(status, :post_type => 'page').find_by_post_slug(segments[0])

			end

			gloalize @content
			render_404 and return if @content.nil?

			if !@content.post_template.blank?

				if File.exists?("app/views/pages/template-#{@content.post_template.downcase}.html.erb")

					render :template => "pages/template-#{@content.post_template.downcase}"

				else

					render :template => "pages/page"

				end

			else

				render :template => "pages/page"

			end


		end

	end

end