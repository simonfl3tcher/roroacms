class Admin::TermsController < AdminController

	# displays all the current categories and creates a new category object for creating a new one

	def categories
		# add breadcrumb and set title
		add_breadcrumb "Categories", :admin_post_categories_path, :title => "Back to categories"
		@title = "Categories"

		@terms = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new
		@type = 'category'

		# render view template as it is the same as the tag view
		render 'view'
	end


	# displays all the current tags and creates a new category object for creating a new one

	def tags
		# add breadcrumb and set title
		add_breadcrumb "Tags", :admin_post_tags_path, :title => "Back to tags"
		@title = "Tags"

		@terms = Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new
		@type = 'tag'

		# render view template as it is the same as the category view
		render 'view'
	end


	# create tag or category - this is set within the form

	def create
		@category = Term.new(term_params)
		
		# deal with any abnormalaties which just makes sure there are "-" instead of spaces within the slug
		@category.deal_with_abnormalaties

		# redirect url will be different for either tag or category
		redirect_url = Term.get_redirect_url params
		type = Term.get_type_of_term params

		respond_to do |format|

		  if @category.save

		  	@term_anatomy = @category.create_term_anatomy(:taxonomy => params[:type_taxonomy])
		  	Term.update_slug_for_subcategories(@category.id, @category.structured_url, true)
		    format.html { redirect_to send(redirect_url), notice: "#{type} was successfully created." }

		  else

		  	flash[:error] = 'Please make sure the slug is unique.'
		    format.html { redirect_to send(redirect_url) }

		  end

		end
	end


	# get the term record to be edited

	def edit 
		@category = Term.find(params[:id])
		@title = edit_title()
		@type = @category.term_anatomy.taxonomy

	end


	# update the term record with the given parameters

	def update
	    @category = Term.find(params[:id])

	    # redirect url will be different for either tag or category
	    redirect_url = Term.get_redirect_url params
	    type = Term.get_type_of_term params
	   	old_url = @category.structured_url

	    respond_to do |format|
	    	# deal with abnormalaties - update the structure url 
			if @category.update_attributes(term_params)
			    Term.update_slug_for_subcategories(@category.id, old_url, true)
				format.html { redirect_to edit_admin_term_path(@category), notice: "#{type} was successfully updated" }
			else
				format.html { 
					@title = edit_title()
					render action: "edit" 
				}
			end

	    end
	end

	# set the title and breadcrumbs for the edit screen

	def edit_title

		if @category.term_anatomy.taxonomy == 'category' 
			add_breadcrumb "Categories", :admin_post_categories_path, :title => "Back to categories"
			add_breadcrumb "Article Category"
			@title = 'Article Category'
		else
			add_breadcrumb "Tags", :admin_post_tags_path, :title => "Back to tags"
			add_breadcrumb "Article Tag"
			@title = 'Article Tag'
		end

		return @title

	end


	# delete the term

	def destroy
		# return url will be different for either tag or category
	    session[:return_to] = request.referer

	    @term = Term.find(params[:id])
	    @term.destroy

	    respond_to do |format|
	      format.html { redirect_to "#{session[:return_to]}", notice: "Successfully deleted" }
	    end
	end


	# Takes all of the checked options and updates them with the given option selected. 
	# The options for the bulk update in pages area are:-
	# - Delete

	def bulk_update
		notice = Term.bulk_update params
		redirect_url = Term.get_redirect_url params

		respond_to do |format|
	      format.html { redirect_to send(redirect_url), notice: notice }
	    end
	end

	private 
	

	# Strong parameter

	def term_params
		if !session[:admin_id].blank?
			params.require(:term).permit(:name, :parent, :slug, :structured_url, :description, :term_group)
		end
	end

end