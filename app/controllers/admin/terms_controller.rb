class Admin::TermsController < AdminController

	# def index
	# 	abort()
	# 	@categories = Term.order('name asc')
		
	# 	@category = Term.new
	
	# 	# if params.has_key?(:search)
	# 	# 	# @posts = Post.where("id like ? or post_title like ? or post_slug like ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
	# 	# end
	# end

	def categories
		@categories = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)
		@category = Term.new

	end

	def tags
		@categories = Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)
		@category = Term.new

	end

	def create

		taxonomy = params[:type_taxonomy]
		@category = Term.new(params[:term])
		@categories = Term.order('name asc')

		if @category.slug.empty?
			@category.slug = @category.name.gsub(' ', '-')
		else
			@category.slug = @category.slug.gsub(' ', '-')
		end

		if taxonomy == 'category'

			redirect_url = "admin_post_categories_path"
			type = "Category"

		else
			redirect_url = "admin_post_tags_path"
			type = "Tag"

		end


		respond_to do |format|
		  if @category.save
			@term_anatomy = @category.create_term_anatomy(:taxonomy => taxonomy)
		    format.html { redirect_to send(redirect_url), notice:  "#{type} was successfully created" }
		  else
		    format.html { render action: "index" }
		  end
		end
	end

	def edit 
		@category = Term.find(params[:id])
		@type = @category.term_anatomy.taxonomy
	end

	def update
	    @term = Term.find(params[:id])


	    if params[:type_taxonomy] == 'category'

			redirect_url = "admin_post_categories_path"
			type = "Category"

		else
			redirect_url = "admin_post_tags_path"
			type = "Tag"

		end
	    respond_to do |format|
	      if @term.update_attributes(params[:term])
	        format.html { redirect_to send(redirect_url), notice: "#{type} was successfully updated" }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def destroy
	    @term = Term.find(params[:id])

	    if @term.term_anatomy.taxonomy == 'category'

			redirect_url = "admin_post_categories_path"
			type = "Category"

		else
			redirect_url = "admin_post_tags_path"
			type = "Tag"

		end

	    @term.destroy

	    respond_to do |format|
	      format.html { redirect_to send(redirect_url), notice: "#{type} successfully deleted" }
	    end

	end

	def bulk_update
		action = params[:to_do]
		action = action.gsub(' ', '_')

		if params[:categories].nil?
			action = ""
		end

		if params[:type_taxonomy] == 'category'

			redirect_url = "admin_post_categories_path"
			type = "Categories"

		else
			redirect_url = "admin_post_tags_path"
			type = "Tags"

		end
		case action.downcase 
			when "move_to_trash"
				bulk_update_move_to_trash params[:categories]
				respond_to do |format|
			      format.html { redirect_to send(redirect_url), notice: "#{type} were successfully moved to trash" }
			    end
			else

				respond_to do |format|
			      format.html { redirect_to send(redirect_url), notice: 'Nothing was done' }
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