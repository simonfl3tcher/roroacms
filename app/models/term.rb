class Term < ActiveRecord::Base

	has_many :term_relationships
	has_many :term_relationships_banners
	
	has_many :posts, :through => :term_relationships
	has_many :banners, :through => :term_relationships_banners

	has_one :term_anatomy, :dependent => :destroy

  	validates :name, :presence => true

  	validates_uniqueness_of :slug
  	validates_format_of :slug, :with => /^[A-Za-z0-9-]*$/

  	def self.create params

		taxonomy = params[:type_taxonomy]

  	end

  	def self.get_redirect_url params

  		taxonomy = params[:type_taxonomy]
		if taxonomy == 'category'

			redirect_url = "admin_post_categories_path"
			type = "Category"

		elsif taxonomy == 'banner'

			redirect_url = "categories_admin_banners_path"
			type = "Banner category"

		else

			redirect_url = "admin_post_tags_path"
			type = "Tag"

		end

		return redirect_url
  	end

  	def self.get_type_of_term params

	    taxonomy = params[:type_taxonomy]
		
		if taxonomy == 'category'
			type = "Category"
		elsif taxonomy == 'banner'
			type = "Banner category"
		else
			type = "Tag"
		end

		return type

  	end

  	def self.bulk_update params

  		if !params[:to_do].blank?
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
				when "destroy"
					bulk_update_move_to_trash params[:categories]
				    return "#{type} were successfully deleted" 
				else
				    return 'Nothing was done'
			end
		end

  	end

  	def self.deal_with_abnormalaties category

  		if category.slug.blank?
			category.slug = category.name.gsub(' ', '-').downcase
		else
			category.slug = category.slug.gsub(' ', '-').downcase
		end

		return category

  	end


	private 

	def self.bulk_update_move_to_trash params
		params.each do |val|
			@category = Term.find(val)
			@category.destroy
		end
	end


end
