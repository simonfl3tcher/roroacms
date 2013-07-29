class Admin::BannersController < AdminController

	before_filter :authorize_admin

	def index 
		@banners = Banner.setup_and_search_posts params
	end


	def edit 
		@banner_categories = Banner.get_banner_categories
		@banner = Banner.find(params[:id])
	end

	def update
	    @banner = Banner.find(params[:id])

	    respond_to do |format|

	      if @banner.update_attributes(banner_params)

	      	Banner.deal_with_categories(@banner, params[:category_ids], true)

	        format.html { redirect_to edit_admin_banner_path(@banner), notice: 'Banner was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end

	    end

	end

	def new
		@banner_categories = Banner.get_banner_categories
	    @banner = Banner.new
	end

	def create
		@banner_categories = Banner.get_banner_categories
		@banner = Banner.new(banner_params)

		respond_to do |format|
		  if @banner.save
		  	Banner.deal_with_categories(@banner, params[:category_ids])
		    format.html { redirect_to admin_banners_path, notice: 'Banner was successfully created.' }
		  else
		    format.html { render action: "new" }
		  end

		end

	end

	def destroy
	    @banner = Banner.find(params[:id])
	    @banner.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_banners_path, notice: 'Banner was successfully deleted.' }
	    end

	end

	def categories
		@categories = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		@category = Term.new

	end

	def bulk_update

		func = Banner.bulk_update params

		respond_to do |format|
	      format.html { redirect_to admin_banners_path, notice: "Banners were successfully deleted" }
	    end

	end

	private

	def banner_params
		if !session[:admin_id].blank?
			params.require(:banner).permit(:name, :image, :description, :sort_order)
		end
	end


end