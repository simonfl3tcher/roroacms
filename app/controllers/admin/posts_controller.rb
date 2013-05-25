class Admin::PostsController < AdminController

	def index

			@posts = Post.where(:disabled => 'N', :post_type => 'post', ).order('post_date desc')
			if params.has_key?(:search) && !params[:search].blank?
				@posts = Post.where("(id like ? or post_title like ? or post_slug like ?) and disabled = 'N' and post_type = 'post' and post_status != 'Autosave'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
			end

			if params.has_key?(:pagination)
				@posts = Post.where(:disabled => 'N', :post_type => 'post', ).order('post_date desc').limit(params[:pagination])
			end
	end

	def new
	    @post = Post.new
	end

	def create
		@cats = params[:category_ids]
		@tags = params[:tag_ids]
		@post = Post.new(params[:post])

		if @post.post_slug.empty?
			@post.post_slug = @post.post_title.gsub(' ', '-').downcase
		end

		if @post.post_status.blank?
	    	@post.post_status = 'Draft'
	    end

		respond_to do |format|
		  if @post.save
			if !@cats.blank?
				@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end
			if !@tags.blank?
				@tags.each do |val|
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end

		    format.html { redirect_to admin_posts_path, notice: 'Post was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end
		end
	end

	def edit 
		@revisions = Post.where(:post_parent => params[:id], :post_type => 'autosave').order('created_at desc')
		@post = Post.find(params[:id])
	end

	def update
	    @post = Post.find(params[:id])
	    @cats = params[:category_ids]
	    @tags = params[:tag_ids]

	    respond_to do |format|
	      if @post.update_attributes(params[:post])
	      	
	      	@delcats = TermRelationship.where(:post_id => @post.id)

	      	if !@delcats.blank?
	      		@delcats.each do |f|

		      		@cat = TermRelationship.find(f.id)
		    		@cat.destroy

	      		end
	      		# TermRelationship.delete_all('post_id = ?', @post.id)
	    	end

	    	if !@cats.blank?
	    		@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end
			if !@tags.blank?
	    		@tags.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end

	        format.html { redirect_to edit_admin_post_path(@post), notice: 'Post was successfully updated.' }
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
	      format.html { redirect_to admin_posts_path, notice: 'Post was successfully put into trash can.' }
	    end

	end

	def autosave_create
		# This function is not in use at the moment but can easily be swtiched on!
		@cats = params[:category_ids]
		@post = Post.new(params[:post])


		if @post.post_slug.empty?
			@post.post_slug = @post.post_title.gsub(' ', '-')
		end

	    @post.post_status = 'Autosave'
	    @post.post_type = 'autosave'

		if @post.save(:validate => false)
			if !@cats.blank?
				@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end
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
		@autosave_records = Post.where("post_parent = ? and post_type = 'autosave'", parent).order("created_at DESC")

		if @autosave_records.length > 9
			Post.destroy(@autosave_records.last[:id])
		end
		
		# Do the autosave
		@cats = params[:category_ids]
		@post = Post.new(params[:post])

		@post.id = nil
		@post.post_parent = params[:post][:id]

		if @post.post_slug.empty?
			@post.post_slug = @post.post_title.gsub(' ', '-')
		end

	    @post.post_status = 'Autosave'
	    @post.post_type = 'autosave'

		if @post.save(:validate => false)
			@delcats = TermRelationship.where(:post_id => @post.id)

	      	if !@delcats.blank?
	      		@delcats.each do |f|

		      		@cat = TermRelationship.find(f.id)
		    		@cat.destroy

	      		end
	      		# TermRelationship.delete_all('post_id = ?', @post.id)
	    	end
	    	if !@cats.blank?
				@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationship.create(:term_id => val, :post_id => @post.id)
				end
			end
			@revisions = Post.where(:post_parent => params[:post][:id], :post_type => 'autosave').order('created_at desc')
			render :partial => "autosave_list"
			return @return = "passed"
		else
			return render :text => "failed" 
		end

	end

	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:posts].nil?
			action = ""
		end

		case action.downcase 
			when "publish"
				bulk_update_publish params[:posts]
				respond_to do |format|
			      format.html { redirect_to admin_posts_path, notice: 'Posts were successfully published' }
			    end
			when "draft"
				bulk_update_draft params[:posts]
				respond_to do |format|
			      format.html { redirect_to admin_posts_path, notice: 'Posts were successfully set to draft' }
			    end
			when "move_to_trash"
				bulk_update_move_to_trash params[:posts]
				respond_to do |format|
			      format.html { redirect_to admin_posts_path, notice: 'Posts were successfully moved to trash' }
			    end
			else
			
			respond_to do |format|
		      format.html { redirect_to admin_posts_path, notice: 'Nothing was done' }
		    end
		end
	end

	def update_from_air

		post = Post.find(params[:id])
		post.post_content = params[:html]
		post.save


		return render :text => "The object is #{session}"

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