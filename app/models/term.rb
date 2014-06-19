class Term < ActiveRecord::Base

	# relations, validations and scope

	has_many :term_relationships
	has_many :posts, :through => :term_relationships
	has_one :term_anatomy, :dependent => :destroy
  	validates :name, :slug, :presence => true
  	validates_format_of :slug, :with => /\A[A-Za-z0-9-]*\z/
  	validates_uniqueness_of :slug, :on => :create

  	CATEGORIES = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'category'}).order('name asc')
  	TAGS = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'tag'}).order('name asc')

  	
  	def self.create(params)
		taxonomy = params[:type_taxonomy]
  	end

  	# returns a redirect url depending on the type of taxonomy that you have edited

  	def self.get_redirect_url(params)

  		if !params[:type_taxonomy].blank?
	  		taxonomy = params[:type_taxonomy]
			
			if taxonomy == 'category'
				redirect_url = "/admin/article/categories"
				type = I18n.t("models.term.generic.category") # are these actually needed?
			else
				redirect_url = "/admin/article/tags"
				type = I18n.t("models.term.generic.tag") # are these actually needed?
			end

			redirect_url
		else
			"/admin"
		end

  	end

  	# returns a taxonomy type depending on the parameters for a message

  	def self.get_type_of_term(params)

	    taxonomy = params[:type_taxonomy]
		
		if taxonomy == 'category'
			type = I18n.t("models.term.generic.category")
		else
			type = I18n.t("models.term.generic.tag")
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

				redirect_url = "admin_article_categories_path"
				type = I18n.t("generic.categories")

			else

				redirect_url = "admin_article_tags_path"
				type = I18n.t("generic.tags")

			end

			case action.downcase 
				when "destroy"
					bulk_update_move_to_trash params[:categories]
				    return I18n.t("models.term.bulk_update.deleted", type: type)
				else
				    return I18n.t("generic.nothing")
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

		self.structured_url = '/' + self.slug

  	end

  	# update the url in sub pages if the url changes 

  	def self.update_slug_for_subcategories(term_id, old_url, initial = true)

  		# find all the records with the old url - change the url to use the new one
  		term = Term.find(term_id)

  		if initial

	  		str_url = '/' + term.slug 
			# make sure you prepend the parent structured url if parent exitst
			if !term.parent.blank?
				str_url = Term.find(term.parent.to_i).structured_url + str_url
			end
			term.structured_url = str_url
			term.save

		end


  		if term.structured_url != old_url
  			Term.where(parent: term.id).each do |f|
  				t = Term.find(f.id)
  				
  				url_old = t.structured_url
  				
  				t.structured_url = t.structured_url.gsub(old_url + '/', term.structured_url + '/')
  				t.save

  				if !t.parent.blank?
  					update_slug_for_subcategories(t.id, url_old, false)
  				end

  			end
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
