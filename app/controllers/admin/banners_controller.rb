class Admin::BannersController < AdminController

	before_filter :authorize_admin

	def index 
		@banners = Banner.all
	end


	def edit 
		@banner = Banner.find(params[:id])
	end

	def update
	    @banner = Banner.find(params[:id])
	    @cats = params[:category_ids]

	    respond_to do |format|
	      if @banner.update_attributes(params[:banner])

	      	@delcats = TermRelationshipsBanner.where(:banner_id => @banner.id)

	      	if !@delcats.blank?
	      		@delcats.each do |f|

		      		@cat = TermRelationshipsBanner.find(f.id)
		    		@cat.destroy

	      		end
	      		# TermRelationship.delete_all('post_id = ?', @post.id)
	    	end

	    	if !@cats.blank?
	    		@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationshipsBanner.create(:term_id => val, :banner_id => @banner.id)
				end
			end
	        format.html { redirect_to edit_admin_banner_path(@banner), notice: 'Banner was successfully updated.' }
	      else
	        format.html { render action: "edit" }
	      end
	    end
	end

	def new
	    @banner = Banner.new
	end

	def create
		@banner = Banner.new(params[:banner])
		@cats = params[:category_ids]

		respond_to do |format|
		  if @banner.save
		  	if !@cats.blank?
				@cats.each do |val|
					# return render :text => "The object is #{val}"
					TermRelationshipsBanner.create(:term_id => val, :banner_id => @banner.id)
				end
			end
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
		@categories = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)
		@category = Term.new

	end

end