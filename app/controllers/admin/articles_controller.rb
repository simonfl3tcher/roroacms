class Admin::ArticlesController < AdminController

	add_breadcrumb I18n.t("generic.articles"), :admin_articles_path, :title => I18n.t("controllers.admin.articles.breadcrumb_title")

	# displays all the "posts" with the post_type of "page". This is also set up 
	# to take search parameters so you can search for an individual page itself.

	before_filter :set_post_type

	def index
		# set title
		set_title(I18n.t("generic.articles"))
		@posts = Post.setup_and_search_posts params, 'post'
	end


	# creates a new post object. But it also gets the current tags/categories 
	# that you can assign to the post.

	def new
		# add breadcrumb and set title
		add_breadcrumb I18n.t("controllers.admin.articles.new.breadcrumb")
		set_title(I18n.t("controllers.admin.articles.new.title"))

	    @record = Post.new
	    @action = 'create'
	end


	# create the post object

	def create
		@record = Post.new(post_params)

		# simply does some checks and updates so the data is correct when entering the data
		# the things it checks/updates are:-
		# - post slug
		# - post status
		# - structured url

		@record.deal_with_abnormalaties
		@record.additional_data(params[:additional_data]) if !params[:additional_data].blank?

		respond_to do |format|
		  
		  if @record.save

		  	# assigns and unassigns categories and tags to an individual posts
			Post.deal_with_categories @record, params[:category_ids], params[:tag_ids]

		    format.html { redirect_to admin_articles_path, notice: I18n.t("controllers.admin.articles.create.flash.success") }

		  else
		    format.html { 
		    	# add breadcrumb and set title
				add_breadcrumb I18n.t("controllers.admin.articles.new.breadcrumb")
				@action = 'create'
		    	render action: "new" 
		    }
		  end

		end
	end


	# gets and displays the post object with the necessary dependencies 

	def edit 
		# add breadcrumb and set title
		add_breadcrumb I18n.t("controllers.admin.articles.edit.breadcrumb")
		set_title(I18n.t("controllers.admin.articles.edit.title"))

		@edit = true
		@action = 'update'
		@record = Post.find(params[:id])
	end


	# updates the post object with the updates params

	def update
	    @record = Post.find(params[:id])
	    @record.additional_data(params[:additional_data]) if !params[:additional_data].blank?

	    respond_to do |format|
	      
	      if @record.update_attributes(post_params)
	      	
	      	# assigns and unassigns categories and tags to an individual posts
	      	Post.deal_with_categories @record, params[:category_ids], params[:tag_ids], true
	        format.html { redirect_to edit_admin_article_path(@record), notice: I18n.t("controllers.admin.articles.update.flash.success") }
	      
	      else
	        format.html { 
	        	# add breadcrumb and set title
				add_breadcrumb I18n.t("controllers.admin.articles.edit.breadcrumb")
				@action = 'update'
	        	render action: "edit" 
	        }
	      end

	    end
	end


	# delete the post

	def destroy
	    Post.disable_post params[:id]

	    respond_to do |format|
	      format.html { redirect_to admin_articles_path, notice: I18n.t("controllers.admin.articles.destroy.flash.success") }
	    end
	end


	# is called via an ajax call on BOTH post/page this saves the current state post every 2 mins
	# and saves it as a "autosave" these posts are then displayed as revisions underneath the post editor

	def autosave_update
		post = Post.new(post_params)
		ret = Post.do_autosave params, post

		if ret == 'passed'

			@record = Post.find(params[:post][:id])
      		render :partial => "admin/partials/revision_tree"

		else
			return render :text => "f" 
		end

	end


	# Takes all of the checked options and updates them with the given option selected. 
	# The options for the bulk update in pages area are:-
	# - Publish
	# - Draft
	# - Move to trash

	def bulk_update
		notice = Post.bulk_update params, 'posts'

		respond_to do |format|
	      format.html { redirect_to admin_articles_path, notice: notice }
	    end
	end


	# used for an ajax call will take the key and return the necessary html for the view and return it

	def create_additional_data
		@key = params[:key].gsub(/[^0-9A-Za-z_-]/, '')
		print render :partial => 'admin/partials/post_additional_data_view'
	end



	private 

	# Strong parameters

	def post_params
		params.require(:post).permit(:admin_id, :post_content, :post_date, :post_name, :parent_id, :post_slug, :sort_order, :post_visible, :post_additional_data, :post_status, :post_title, :post_image, :post_template, :post_type, :disabled, :post_seo_title, :post_seo_description, :post_seo_keywords, :post_seo_is_disabled, :post_seo_no_follow, :post_seo_no_index)
	end

	# used for the form to set the type of post as the form is used for both articles and pages 

	def set_post_type 
		@post_type ||= 'post'
	end

end