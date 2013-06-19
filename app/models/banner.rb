class Banner < ActiveRecord::Base

	paginates_per(Setting.get('pagination_per').to_i)

	has_many :term_relationships_banners, :dependent => :destroy
	has_many :terms, :through => :term_relationships_banners

	validates :name, :image, :presence => true

	BANNER_CATEGORIES = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)

	def self.deal_with_categories banner, cats, del = false 

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
end
