class Admin::BannersController < AdminController

	# list out all of the banners

	def index 
		@banners = Banner.setup_and_search_posts params
	end

	# get and disply certain banner

	def edit 
		# get a list of the banner categories
		@banner_categories = Banner.get_banner_categories
		@banner = Banner.find(params[:id])
	end

	# update the banner with the given params

	def update
	    @banner = Banner.find(params[:id])

	    respond_to do |format|

	      if @banner.update_attributes(banner_params)

	      	# Will update the categories that the banner is tagged in
	      	Banner.deal_with_categories(@banner, params[:category_ids], true)

	        format.html { redirect_to edit_admin_banner_path(@banner), notice: 'Banner was successfully updated.' }

	      else
	        format.html { render action: "edit" }
	      end

	    end
	end

	# create a new banner object

	def new
		# get a list of the banner categories
		@banner_categories = Banner.get_banner_categories
	    @banner = Banner.new
	end

	# actually create the new banner with the given param data

	def create
		@banner_categories = Banner.get_banner_categories
		@banner = Banner.new(banner_params)

		respond_to do |format|

		  if @banner.save

		  	# will update the categories that the banner is tagged in
		  	Banner.deal_with_categories(@banner, params[:category_ids])
		    format.html { redirect_to admin_banners_path, notice: 'Banner was successfully created.' }

		  else
		    format.html { render action: "new" }
		  end

		end

	end

	# Delete the banner

	def destroy
	    @banner = Banner.find(params[:id])
	    @banner.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_banners_path, notice: 'Banner was successfully deleted.' }
	    end
	end

	# Will display a page with the banner categories and the option to add a new banner

	def categories
		# current banner categories
		@categories = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy).page(params[:page]).per(Setting.get_pagination_limit)
		
		# new banner category object
		@category = Term.new
	end

	# bulk update function - this will update all of the checked options on the page. 

	def bulk_update
		func = Banner.bulk_update params

		respond_to do |format|
			# currently in the banners area there is only one option - to bulk delete the banner options.
	      format.html { redirect_to admin_banners_path, notice: "Banners were successfully deleted" }
	    end
	end

	private

	# Strong parameters

	def banner_params
		if !session[:admin_id].blank?
			params.require(:banner).permit(:name, :image, :description, :sort_order)
		end
	end


end