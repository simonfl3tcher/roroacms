class PagesController < ApplicationController
		
	def index

		home_id = Setting.where(:setting_name => 'home_page').first.setting
		gloalize Post.find(home_id)
		render :template => "pages/home"

 	end

 	def show
 		post = Post.find(params[:id])
 		article_url = Setting.where(:setting_name => 'articles_slug').first.setting

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

		if !session[:admin_id].blank?

			# abort('in here')

			status = "(post_status = 'Published' or post_status = 'Draft')"

		else

			status = "post_status = 'Published'"

		end

		if segments[0] == article_url

			if !segments[1].blank?

				if segments[1] == category_url

					if segments[2].blank?
						redirect_to "blog"

					else

						term = Term.where(:slug => segments[2])
						gloalize Post.where(terms: {id: term}, :post_type => 'post').includes(:terms)
						render :template => "pages/category"


					end


				elsif segments[1].nonnegative_float?

					if !segments[3].blank?

						gloalize Post.where("#{status} AND (YEAR(post_date) = ? AND MONTH(post_date) = ? AND DAY(post_date) = ?)", segments[1], segments[2], segments[3])
						render :template => "pages/archive"

					elsif !segments[2].blank?

						gloalize Post.where("#{status} AND (YEAR(post_date) = ? AND MONTH(post_date) = ?)", segments[1], segments[2])
						render :template => "pages/archive"

					else

						gloalize Post.where("#{status} AND (YEAR(post_date) = ?)", segments[1])
						render :template => "pages/archive"

					end


				else

					gloalize Post.where(status, :post_type => 'post').find_by_post_slug(segments[1])
					render_404 and return if @content.nil?
					@comment = Comment.new
					render :template => "pages/single"

				end

			else
				gloalize Post.where(status, :post_type => 'post')
				render :template => "pages/category"
			end

		else

			gloalize Post.where(status, :post_type => 'page').find_by_post_slug(segments[0])
			render_404 and return if @content.nil?
			render :template => "pages/page"

		end

	end

end