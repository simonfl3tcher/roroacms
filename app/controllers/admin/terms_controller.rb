class Admin::TermsController < AdminController

	def categories
		@categories = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new

	end

	def tags
		@tags = Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new

	end

	def create

		@category = Term.new(term_params)
		@category = Term.deal_with_abnormalaties @category

		
		redirect_url = Term.get_redirect_url params
		type = Term.get_type_of_term params

		respond_to do |format|
		  if @category.save
		  	@term_anatomy = @category.create_term_anatomy(:taxonomy => params[:type_taxonomy])
		    format.html { redirect_to send(redirect_url), notice: "#{type} was successfully created." }
		  else
		    format.html { render action: "new" }
		  end
		end

	end

	def edit 
		@category = Term.find(params[:id])
		@type = @category.term_anatomy.taxonomy
	end

	def update
	    @term = Term.find(params[:id])
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

	def destroy
	    @term = Term.find(params[:id])
	    @term.destroy
	    
	    redirect_url = Term.get_redirect_url params
	    type = Term.get_type_of_term params

	    respond_to do |format|
	      format.html { redirect_to send(redirect_url), notice: "#{type} successfully deleted" }
	    end

	end

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