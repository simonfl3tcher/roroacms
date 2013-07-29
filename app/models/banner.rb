class Banner < ActiveRecord::Base

	paginates_per(Setting.get('pagination_per').to_i)

	has_many :term_relationships_banners, :dependent => :destroy
	has_many :terms, :through => :term_relationships_banners

	validates :name, :image, :presence => true
	@code = rand(10**10)

	BANNER_CATEGORIES = Term.where('?=?', @code, @code).where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)

	def self.deal_with_categories(banner, cats, del = false)

			if del 

		      	@delcats = TermRelationshipsBanner.where(:banner_id => banner.id)

		      	if !@delcats.blank?
		      		@delcats.each do |f|

			      		cat = TermRelationshipsBanner.find(f.id)
			    		cat.destroy

		      		end
		    	end
		    end

	    	if !cats.blank?
	    		cats.each do |val|
					TermRelationshipsBanner.create(:term_id => val, :banner_id => banner.id)
				end
			end

	end

	def self.get_banner_categories
		banner_c = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)
		return banner_c
	end

	def self.setup_and_search_posts(params)

		banners = Banner.where('1=1').page(params[:page]).per(Setting.get_pagination_limit)
		if params.has_key?(:search) && !params[:search].blank?
			banners = Banner.where("(name like ?)",  "%#{params[:search]}%").page(params[:page]).per(Setting.get_pagination_limit)
		end

	     return banners

	end  

	def self.bulk_update(params)

		action = params[:to_do]
		action = action.gsub(' ', '_')

		case action.downcase 
			when "move_to_trash"
				bulk_update_destroy params[:banners]
		end

	end
	def self.bulk_update_destroy(banners)
		banners.each do |val|
			banner = Banner.find(val)
			banner.destroy
		end
	end

end
