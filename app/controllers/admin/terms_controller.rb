class Admin::TermsController < AdminController

	def index 
		@categories = Term.order('name asc')
		
		@category = Term.new
	
		# if params.has_key?(:search)
		# 	# @posts = Post.where("id like ? or post_title like ? or post_slug like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
		# end
	end

	def create
		@category = Term.new(params[:term])
		@categories = Term.order('name asc')

		if @category.slug.empty?
			@category.slug = @category.name.gsub(' ', '-')
		end


		respond_to do |format|
		  if @category.save
			@term_anatomy = @category.create_term_anatomy(:description => params[:description], :taxonomy => "category")
		    format.html { redirect_to admin_post_categories_path, notice: 'Category was successfully created' }
		  else
		    format.html { render action: "index" }
		  end
		end
	end

	def edit 
		@category = Term.find(params[:id])
	end

	def update
	    @term = Term.find(params[:id])

	    respond_to do |format|
	      if @term.update_attributes(params[:term])
	        format.html { redirect_to admin_post_categories_path(@term), notice: 'Category was successfully updated' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @term = Term.find(params[:id])
	    @term.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_post_categories_path, notice: 'Category successfully deleted' }
	    end

	end

	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:categories].nil?
			abort('123131');
			action = ""
		end

		case action.downcase 
			when "move_to_trash"
				bulk_update_move_to_trash params[:categories]
				respond_to do |format|
			      format.html { redirect_to admin_post_categories_path, notice: 'Categories were successfully moved to trash' }
			    end
			else

				respond_to do |format|
			      format.html { redirect_to admin_post_categories_path, notice: 'Nothing was done' }
			    end
		end
	end

	private 

	def bulk_update_move_to_trash params
		params.each do |val|
			@category = Term.find(val)
			@category.destroy
		end
	end
end