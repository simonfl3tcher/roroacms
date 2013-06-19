class Admin::PagesController < AdminController

	def index

		@pages = Post.setup_and_search_posts params, 'page'
	end

	def new
	    @page = Post.new
	end

	def create
		@page = Post.new(page_params)
		@page = Post.deal_with_abnormalaties @page

		respond_to do |format|
		  if @page.save
		    format.html { redirect_to admin_pages_path, notice: 'Page was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end

	def edit 
		@revisions = Post.where(:parent_id => params[:id], :post_type => 'autosave').order('created_at desc')
		@page = Post.find(params[:id])
	end

	def update
		Rails.cache.clear 
	    @page = Post.find(params[:id])

	    respond_to do |format|
	      if @page.update_attributes(page_params)

	        format.html { redirect_to edit_admin_page_path(@page), notice: 'Page was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	   Post.disable_post params[:id]
	    respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: 'Page was successfully put into trash can.' }
	    end
	end

	def autosave_update
		@post = Post.new(post_params)
		ret = Post.do_autosave params, @post

		if ret == 'passed'
			@revisions = Post.where(:parent_id => params[:post][:id], :post_type => 'autosave').order('created_at desc')
      		render :partial => "autosave_list"
			return @return = "passed"
		else
			return render :text => "failed" 
		end

	end

	def bulk_update
		notice = Post.bulk_update params, 'pages'
		respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: notice }
	    end
	end

	private

	def page_params
		if !session[:admin_id].blank?	
			params.require(:post).permit(:admin_id, :post_content, :post_date, :post_name, :parent_id, :post_slug, :post_status, :post_title, :post_template, :post_type, :disabled, :post_seo_title, :post_seo_description, :post_seo_keywords, :post_seo_is_disabled, :post_seo_no_follow, :post_seo_no_index)
		end
	end
end