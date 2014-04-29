class Term < ActiveRecord::Base

	# relations, validations and scope

	has_many :term_relationships
	has_many :term_relationships_banners
	has_many :posts, :through => :term_relationships
	has_many :banners, :through => :term_relationships_banners
	has_one :term_anatomy, :dependent => :destroy
  	validates :name, :presence => true
  	validates_format_of :slug, :with => /^[A-Za-z0-9-]*$/
  	validates_uniqueness_of :slug

  	
  	def self.create(params)
		taxonomy = params[:type_taxonomy]
  	end

  	# returns a redirect url depending on the type of taxonomy that you have edited

  	def self.get_redirect_url(params)

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

		redirect_url

  	end

  	# returns a taxonomy type depending on the parameters for a message

  	def self.get_type_of_term(params)

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

  	# is the bootstrap for the bulk update function. It takes in the call
    # and decides what function to call in order to get the correct output

  	def self.bulk_update(params)

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

  	# will make sure that specific data is correctly formatted for the database

  	def deal_with_abnormalaties

  		# if the slug is empty it will take the name and create a slug
  		if self.slug.blank?
			self.slug = self.name.gsub(' ', '-').downcase
		else
			self.slug = self.slug.gsub(' ', '-').downcase
		end

  	end


	private 

	# move all of the given taxonomys to the trash area

	def self.bulk_update_move_to_trash(params)
		params.each do |val|
			@category = Term.find(val)
			@category.destroy
		end
	end


end
