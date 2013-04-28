class Admin::PagesController < AdminController

	def index

		@pages = Post.where(:disabled => 'N', :post_type => 'page').order('post_date desc')
		if params.has_key?(:search)
			@pages = Post.where("(id like ? or post_title like ? or post_slug like ?) and post_type = 'page'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
		end
	end

	def new
	    @page = Post.new
	end

	def create
		@page = Post.new(params[:post])

		@page.post_type = 'Page'

		if @page.post_slug.empty?
			@page.post_slug = @page.post_title.gsub(' ', '-')
		end

		if @page.post_status.blank?
	    	@page.post_status = 'Draft'
	    end

		respond_to do |format|
		  if @page.save

		    format.html { redirect_to admin_pages_path, notice: 'Post was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end

	def edit 
		@page = Post.find(params[:id])
	end

	def update
	    @page = Post.find(params[:id])

	    respond_to do |format|
	      if @page.update_attributes(params[:post])

	        format.html { redirect_to edit_admin_page_path(@page), notice: 'Page was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    post = Post.find(params[:id])
	    post.disabled = "Y"
	    post.save

	    respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: 'Page was successfully put into trash can.' }
	    end

	end

	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "publish"
				bulk_update_publish params[:pages]
				respond_to do |format|
			      format.html { redirect_to admin_pages_path, notice: 'Pages were successfully published' }
			    end
			when "draft"
				bulk_update_draft params[:pages]
				respond_to do |format|
			      format.html { redirect_to admin_pages_path, notice: 'Pages were successfully set to draft' }
			    end
			when "move_to_trash"
				bulk_update_move_to_trash params[:pages]
				respond_to do |format|
			      format.html { redirect_to admin_pages_path, notice: 'Pages were successfully moved to trash' }
			    end
		end
	end


	private 

	def bulk_update_publish params
		params.each do |val|
			post = Post.find(val)
			post.post_status = "Published"
			post.post_date = Time.now.utc.to_s(:db)
			post.save
		end
	end

	def bulk_update_draft params
		params.each do |val|
			post = Post.find(val)
			post.post_status = "Draft"
			post.save
		end	
	end

	def bulk_update_move_to_trash params
		params.each do |val|
			post = Post.find(val)
			post.disabled ="Y"
			post.save
		end
	end
end