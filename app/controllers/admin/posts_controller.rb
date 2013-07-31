class Admin::PostsController < AdminController


	def index
		@posts = Post.setup_and_search_posts params, 'post'
	end

	def new
		
		@categories = Post.get_cats
		@tags = Post.get_tags

	    @post = Post.new
	
	end

	def create
		 
		@post = Post.new(post_params)

		@post.deal_with_abnormalaties

		respond_to do |format|
		  if @post.save
			Post.deal_with_categories @post, params[:category_ids], params[:tag_ids]
		    format.html { redirect_to admin_posts_path, notice: 'Post was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end

	def edit 
		@edit = true
		@categories = Post.get_cats
		@tags = Post.get_tags
		
		@revisions = Post.where(:ancestry => params[:id], :post_type => 'autosave').order('created_at desc')
		@post = Post.find(params[:id])
	end

	def update
	    @post = Post.find(params[:id])

	    respond_to do |format|
	      if @post.update_attributes(post_params)
	      	Post.deal_with_categories @post, params[:category_ids], params[:tag_ids], true
	        format.html { redirect_to edit_admin_post_path(@post), notice: 'Post was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	    
	end

	def destroy
	    Post.disable_post params[:id]
	    respond_to do |format|
	      format.html { redirect_to admin_posts_path, notice: 'Post was successfully put into trash can.' }
	    end

	end

	def autosave_update
		@post = Post.new(post_params)
		ret = Post.do_autosave params, @post

		if ret == 'passed'
			@revisions = Post.where(:ancestry => params[:post][:id], :post_type => 'autosave').order('created_at desc')
      		render :partial => "autosave_list"
			return @return = "passed"
		else
			return render :text => "failed" 
		end

	end

	def bulk_update
		notice = Post.bulk_update params, 'posts'
		respond_to do |format|
	      format.html { redirect_to admin_posts_path, notice: notice }
	    end

	end

	def update_from_air

		abort

	end

	def post_params
		if !session[:admin_id].blank?	
			params.require(:post).permit(:admin_id, :post_content, :post_date, :post_name, :parent_id, :post_slug, :post_status, :post_title, :post_template, :post_type, :disabled, :post_seo_title, :post_seo_description, :post_seo_keywords, :post_seo_is_disabled, :post_seo_no_follow, :post_seo_no_index)
		end
	end
end