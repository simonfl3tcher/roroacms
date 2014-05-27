class Admin::PagesController < AdminController

	# displays all the "posts" with the post_type of "page". This is also set up 
	# to take search parameters so you can search for an individual page itself.

	add_breadcrumb "Pages", :admin_pages_path, :title => "Back to pages"

	def index
		@title = 'Pages'
		@pages = Post.setup_and_search_posts params, 'page'
	end


	# creates a new post object

	def new
		# add breadcrumb and set title
		add_breadcrumb "Create New Page"
		@title = 'Create New Page'

		@categories = Post.get_cats

		# get the systems tags
		@tags = Post.get_tags
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

		respond_to do |format|

		  if @page.save
		    format.html { redirect_to admin_pages_path, notice: 'Page was successfully created.' }
		  else
		    format.html { 
		    	# add breadcrumb and set title
				add_breadcrumb "Create New Page"
				@title = 'Create New Page'
		    	render action: "new" 
		    }
		  end

		end
	end


	# gets and displays the post object with the necessary dependencies 

	def edit 
		# add breadcrumb and set title
		add_breadcrumb "Edit Page" 

		@edit = true
		
		# the system creates revisions every 2 mins. Gets these revisions and lists them out below the editor
		@revisions = Post.where(:ancestry => params[:id], :post_type => 'autosave').order('created_at desc')

		@page = Post.find(params[:id])
		@title = 'Edit "' + @page.post_title + '" Page'
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

	        format.html { redirect_to edit_admin_page_path(@page.id), notice: 'Page was successfully updated.' }

	      else
	        format.html { 
	        	# add breadcrumb and set title
				add_breadcrumb "Edit Page" 
				@page.post_title.blank? ? @title = 'Edit Page' : @title = 'Edit "' + @page.post_title + '" Page'
	        	render action: "edit" 
	        }
	      end

	    end
	end


	# deletes the post

	def destroy
	    Post.disable_post params[:id]
	    respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: 'Page was successfully put into trash can.' }
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