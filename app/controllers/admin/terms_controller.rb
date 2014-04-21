class Admin::TermsController < AdminController

	# displays all the current categories and creates a new category object for creating a new one

	def categories

		@categories = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new

	end

	# displays all the current tags and creates a new category object for creating a new one

	def tags

		@tags = Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new

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
		@type = @category.term_anatomy.taxonomy
	
	end

	# update the term record with the given parameters

	def update

	    @term = Term.find(params[:id])

	    # redirect url will be different for either tag or category
	    redirect_url = Term.get_redirect_url params
	    type = Term.get_type_of_term params

	    respond_to do |format|

	      if @term.update_attributes(term_params)
	        format.html { redirect_to send(redirect_url), notice: "#{type} was successfully updated" }
	      else
	        format.html { render action: "edit" }
	      end

	    end

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

	def term_params

		if !session[:admin_id].blank?
			params.require(:term).permit(:name, :slug, :description, :term_group)
		end

	end

end