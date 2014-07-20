class Term < ActiveRecord::Base

  ## misc ##

  has_ancestry

  # has_ancestry

  include MediaHelper

  ## constants ##

  CATEGORIES = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'category'}).order('name asc')
  TAGS = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'tag'}).order('name asc')

  ## associations ##

  has_many :term_relationships
  has_many :posts, :through => :term_relationships
  has_one :term_anatomy, :dependent => :destroy
  has_many :children, :class_name => "Term", :foreign_key => "parent_id", :dependent => :destroy

  ## validations ##

  validates :name, :slug, :presence => true
  validates_format_of :slug, :with => /\A[A-Za-z0-9-]*\z/
  validates_uniqueness_of :slug, :on => :create

  ## callbacks ##

  before_validation :deal_with_abnormalaties
  after_create :deal_with_structured_url
  after_save :deal_with_structured_url

  ## methods ##

  def self.create(params)
    taxonomy = params[:type_taxonomy]
  end

  # returns a redirect url depending on the type of taxonomy that you have edited
  # Params:
  # +params+:: the parameters

  def self.get_redirect_url(params = {})

    if !params[:type_taxonomy].blank?
      params[:type_taxonomy] == 'category' ? "/admin/article/categories" : "/admin/article/tags"
    else
      "/admin"
    end

  end

  # returns a taxonomy type depending on the parameters for a message
  # Params:
  # +params+:: the parameters

  def self.get_type_of_term(params = {})

    taxonomy = params[:type_taxonomy]

    type = 
      if taxonomy == 'category'
        I18n.t("models.term.generic.category")
      else
        I18n.t("models.term.generic.tag")
      end

    type

  end

  # will make sure that specific data is correctly formatted for the database

  def deal_with_abnormalaties

    self.cover_image = upload_images(cover_image, id.to_s, 'terms') if cover_image.class != String && cover_image.class != NilClass

    # if the slug is empty it will take the name and create a slug
    self.slug =
      if slug.blank?
        name.gsub(' ', '-').downcase.gsub(/[^a-z0-9\-\s]/i, '')
      else
        slug.gsub(' ', '-').downcase.gsub(/[^a-z0-9\-\s]/i, '')
      end

    self.structured_url = '/' + self.slug

  end

  # update the url in sub pages if the url changes
  # Params:
  # +term_id+:: ID of the term that you want to use as a reference
  # +old_url+:: the url that you want to replace
  # +initial+:: wether this is the top level term or a sub term of the given ID (mostly used to loop through the function with in the function)

  def update_slug_for_subcategories(term_id, old_url = nil, initial = true)

    # find all the records with the old url - change the url to use the new one
    term = Term.find(term_id)

    if initial
      str_url = '/' + term.slug
      # make sure you prepend the parent structured url if parent exitst
      str_url = (term.parent.structured_url + str_url) if !term.parent_id.blank?
      
      term.structured_url = str_url
      term.save(:validate => false)
    end


    if term.structured_url != old_url
      term.children.each do |f|
        url_old = f.structured_url

        f.structured_url = f.structured_url.gsub(old_url + '/', term.structured_url + '/')
        f.save

        update_slug_for_subcategories(f.id, url_old, false) if !f.parent_id.blank?

      end
    end

  end

  def deal_with_structured_url
    if defined?(self.changes[:structured_url]) && !self.changes[:structured_url].blank?
      old = (defined?(self.changes[:structured_url][0]) && !self.changes[:structured_url][0].blank?) ? self.changes[:structured_url][0] : ''
      update_slug_for_subcategories(self.id, old)
    end
  end


  # is the bootstrap for the bulk update function. It takes in the call
  # and decides what function to call in order to get the correct output
  # Params:
  # +params+:: the parameters

  def self.bulk_update(params = {})

    if !params[:to_do].blank?

      action = params[:to_do].nil? ? "" : params[:to_do].gsub(' ', '_')
      type = params[:type_taxonomy] == 'category' ? I18n.t("generic.categories") : I18n.t("generic.tags")

      case action.downcase
      when "destroy"
        # move all of the given taxonomys to the trash area
        Term.where(:id => params[:categories]).destroy_all
        return I18n.t("models.term.bulk_update.deleted", type: type)
      else
        return I18n.t("generic.nothing")
      end
    end

  end

  # return all of the terms
  # Params:
  # +type+:: the term type you want to return

  def self.term_cats(type = 'category', do_not_include = nil, do_arrange = false)
    t = Term.joins(:term_anatomy).where(term_anatomies: {taxonomy: type})
    t = t.where.not(id: do_not_include) if !do_not_include.blank?
    t = t.order("name").arrange if do_arrange
    t
  end

  # If the has cover image has been removed this will be set to nothing and will update the cover image option agasint the admin
  # Params:
  # +has_cover+:: the has_cover parameter (string)

  def deal_with_cover(has_cover)
    self.cover_image = '' if defined?(has_cover) && has_cover.blank?
  end

end
