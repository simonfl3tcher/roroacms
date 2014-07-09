class Term < ActiveRecord::Base

  ## constants ##

  CATEGORIES = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'category'}).order('name asc')
  TAGS = Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: 'tag'}).order('name asc')

  ## associations ##

  has_many :term_relationships
  has_many :posts, :through => :term_relationships
  has_one :term_anatomy, :dependent => :destroy

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

  def self.get_redirect_url(params = {})

    if !params[:type_taxonomy].blank?
      params[:type_taxonomy] == 'category' ? "/admin/article/categories" : "/admin/article/tags"
    else
      "/admin"
    end

  end

  # returns a taxonomy type depending on the parameters for a message

  def self.get_type_of_term(params)

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

  def update_slug_for_subcategories(term_id, old_url = nil, initial = true)

    # find all the records with the old url - change the url to use the new one
    term = Term.find(term_id)

    if initial
      str_url = '/' + term.slug
      # make sure you prepend the parent structured url if parent exitst
      str_url = (Term.find(term.parent.to_i).structured_url + str_url) if !term.parent.blank?
      
      term.structured_url = str_url
      term.save(:validate => false)
    end


    if term.structured_url != old_url
      Term.where(parent: term.id).each do |f|
        t = Term.find(f.id)

        url_old = t.structured_url

        t.structured_url = t.structured_url.gsub(old_url + '/', term.structured_url + '/')
        t.save

        update_slug_for_subcategories(t.id, url_old, false) if !t.parent.blank?

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

  def self.bulk_update(params)

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

  def self.term_cats type = 'category'
    Term.includes(:term_anatomy).where(term_anatomies: {taxonomy: type}).order('name asc')
  end

end
