class Banner < ActiveRecord::Base

	# relations and validations
	has_many :term_relationships_banners, :dependent => :destroy
	has_many :terms, :through => :term_relationships_banners
	validates :name, :image, :presence => true

	# get all the banners in the system - however if there is a search parameter 
	# search the necessary fields for the given value

	def self.setup_and_search_posts(params)

		banners = Banner.where('1+1=2').page(params[:page]).per(Setting.get_pagination_limit)
		
		if params.has_key?(:search) && !params[:search].blank?
			banners = Banner.where("(name like ?)",  "%#{params[:search]}%").page(params[:page]).per(Setting.get_pagination_limit)
		end

	    return banners

	end  

	# gets called when a banner gets saved to add categories against the banner

	def self.deal_with_categories(banner, cats, delete = false)

		# if delete is true it will remove all relationships with that individual banner
		if delete 
	      	@delcats = TermRelationshipsBanner.where(:banner_id => banner.id)

	      	if !@delcats.blank?

	      		@delcats.each do |f|
		      		cat = TermRelationshipsBanner.find(f.id)
		    		cat.destroy
	      		end

	    	end
	    end

	    # if categories is not blank it will create a new relationship with that banner
    	if !cats.blank?
    		cats.each do |val|
				TermRelationshipsBanner.create(:term_id => val, :banner_id => banner.id)
			end
		end

	end

	# get all categories that are "banner" categories from the term table. 
	# the Term table saves post categories and tags as well as banner cateogories

	def self.get_banner_categories
		banner_c = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)
		return banner_c
	end

	# is the bootstrap for the bulk update function. It takes in the call
	# and decides what function to call in order to get the correct output

	def self.bulk_update(params)
		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "move_to_trash"
				bulk_update_destroy params[:banners]
		end
	end

	# destroys all the banners that are given in an array format

	def self.bulk_update_destroy(banners)
		banners.each do |val|
			banner = Banner.find(val)
			banner.destroy
		end
	end

end
