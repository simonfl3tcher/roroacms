class Admin::PagesController < AdminController

	# displays all the "posts" with the post_type of "page". This is also set up 
	# to take search parameters so you can search for an individual page itself.

	add_breadcrumb I18n.t("controllers.admin.pages.title"), :admin_pages_path, :title => I18n.t("controllers.admin.pages.breadcrumb_title")

	def index
		@title = I18n.t("controllers.admin.pages.title")
		@pages = Post.setup_and_search_posts params, 'page'
	end


	# creates a new post object

	def new
		# add breadcrumb and set title
		add_breadcrumb I18n.t("controllers.admin.pages.new.breadcrumb")
		@title = I18n.t("controllers.admin.pages.new.title")

	    @page = Post.new
	end


	# create the post object

	def create
		@page = Post.new(page_params)

		# simply does some checks and updates so the data is correct when entering the data
		# the things it checks/updates are:-
		# - post slug
		# - post status
		# - structured url

		@page.deal_with_abnormalaties
		@page.additional_data(params[:additional_data]) if !params[:additional_data].blank?

		respond_to do |format|

		  if @page.save
		    format.html { redirect_to admin_pages_path, notice: I18n.t("controllers.admin.pages.create.flash.success") }
		  else
		    format.html { 
		    	# add breadcrumb and set title
				add_breadcrumb I18n.t("controllers.admin.pages.new.breadcrumb")
				@title = I18n.t("controllers.admin.pages.new.title")
		    	render action: "new" 
		    }
		  end

		end
	end


	# gets and displays the post object with the necessary dependencies 

	def edit 

		@edit = true
		@page = Post.find(params[:id])

		# add breadcrumb and set title
		add_breadcrumb I18n.t("controllers.admin.pages.edit.breadcrumb")
		@title = I18n.t("controllers.admin.pages.edit.title", post_title: @page.post_title)
	end


	# updates the post object with the updates params

	def update
	    @page = Post.find(params[:id])
	    
	    # gets the current url
	    cur_url = @page.post_slug

	    # again deals with any bnormalaties
	    @page.deal_with_abnormalaties

	    update_check = Post.do_update_check(Post.find(params[:id]), params[:post])


	    respond_to do |format|

	      if @page.update_attributes(page_params)

	      	# updates the old url and replaces it with the new URL if the name has changed.
	      	Post.deal_with_slug_update params, cur_url

	      	Post.create_user_backup_record(update_check) if !update_check.blank?

	        format.html { redirect_to edit_admin_page_path(@page.id), notice: I18n.t("controllers.admin.pages.update.flash.success") }

	      else
	        format.html { 
	        	# add breadcrumb and set title
				add_breadcrumb I18n.t("controllers.admin.pages.edit.breadcrumb")
				@page.post_title.blank? ? I18n.t("controllers.admin.pages.edit.title_blank") : I18n.t("controllers.admin.pages.edit.title", post_title: @page.post_title)
	        	render action: "edit" 
	        }
	      end

	    end
	end


	# deletes the post

	def destroy
	    Post.disable_post params[:id]
	    respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: I18n.t("controllers.admin.pages.destroy.flash.success") }
	    end
	end


	# Takes all of the checked options and updates them with the given option selected. 
	# The options for the bulk update in pages area are:-
	# - Publish
	# - Draft
	# - Move to trash

	def bulk_update
		# returns a message to disply to the user
		notice = Post.bulk_update params, 'pages'
		respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: notice }
	    end
	end

	private
	

	# Strong parameters

	def page_params
		if !session[:admin_id].blank?	
			params.require(:post).permit(:admin_id, :post_content, :post_date, :post_name, :parent_id, :post_slug, :post_visible, :post_status, :post_title, :post_image, :post_template, :post_type, :disabled, :post_seo_title, :post_seo_description, :post_seo_keywords, :post_seo_is_disabled, :post_seo_no_follow, :post_seo_no_index)
		end
	end
end