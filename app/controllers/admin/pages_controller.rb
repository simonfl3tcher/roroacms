class Admin::PagesController < AdminController

	def index

			@pages = Post.where(:disabled => 'N', :post_type => 'page', ).order('post_date desc')
			if params.has_key?(:search) && !params[:search].blank?
				@pages = Post.where("(id like ? or post_title like ? or post_slug like ?) and disabled = 'N' and post_type = 'page' and post_status != 'Autosave'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
			end

			if params.has_key?(:pagination)
				@pages = Post.where(:disabled => 'N', :post_type => 'page', ).order('post_date desc').limit(params[:pagination])
			end
	end

	def new
	    @page = Post.new
	end

	def create
		@page = Post.new(params[:post])

		if @page.post_slug.empty?
			@page.post_slug = @page.post_title.gsub(' ', '-').downcase
		end

		if @page.post_status.blank?
	    	@page.post_status = 'Draft'
	    end

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
	      if @page.update_attributes(params[:post])

	        format.html { redirect_to edit_admin_page_path(@page), notice: 'Page was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    page = Post.find(params[:id])
	    page.disabled = "Y"
	    page.save

	    respond_to do |format|
	      format.html { redirect_to admin_pages_path, notice: 'Page was successfully put into trash can.' }
	    end

	end

	def autosave_create
		# This function is not in use at the moment but can easily be swtiched on!
		@page = Post.new(params[:post])

		if @page.post_slug.empty?
			@page.post_slug = @page.post_title.gsub(' ', '-')
		end

	    @page.post_status = 'Autosave'
	    @page.post_type = 'autosave'

		if @page.save(:validate => false)
			render :nothing => true
			return @return = "passed"
		else
			return render :text => "failed" 
		end
		# return render :text => @return 

	end

	def autosave_update

		# Check to see if there is more than 15 autosave records and if there is delete the ones that aren't used.
		parent = params[:post][:id]
		@autosave_records = Post.where("parent_id = ? and post_type = 'autosave'", parent).order("created_at DESC")

		if @autosave_records.length > 9
			Post.destroy(@autosave_records.last[:id])
		end
		
		# Do the autosave
		@page = Post.new(params[:post])

		@page.id = nil
		@page.parent_id = params[:post][:id]

		if @page.post_slug.empty?
			@page.post_slug = @page.post_title.gsub(' ', '-')
		end

	    @page.post_status = 'Autosave'
	    @page.post_type = 'autosave'

		if @page.save(:validate => false)

			@revisions = Post.where(:parent_id => params[:post][:id], :post_type => 'autosave').order('created_at desc')
			render :partial => "autosave_list"
			return @return = "passed"
		else
			return render :text => "failed" 
		end

	end

	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:pages].nil?
			action = ""
		end

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
			else
			
			respond_to do |format|
		      format.html { redirect_to admin_pages_path, notice: 'Nothing was done' }
		    end
		end
	end

	def update_from_air

		page = Post.find(params[:id])
		page.post_content = params[:html]
		page.save


		return render :text => "The object is #{session}"

	end

	private 

	def bulk_update_publish params
		params.each do |val|
			page = Post.find(val)
			page.post_status = "Published"
			page.post_date = Time.now.utc.to_s(:db)
			page.save
		end
	end

	def bulk_update_draft params
		params.each do |val|
			page = Post.find(val)
			page.post_status = "Draft"
			page.save
		end	
	end

	def bulk_update_move_to_trash params
		params.each do |val|
			page = Post.find(val)
			page.disabled ="Y"
			page.save
		end
	end
end