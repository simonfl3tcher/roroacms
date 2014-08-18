module Roroacms   
  class Term < ActiveRecord::Base

    ## misc ##

    has_ancestry :orphan_strategy => :adopt 

    # has_ancestry

    include MediaHelper

    ## constants ##

    CATEGORIES = Term.where(roroacms_term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)
    TAGS = Term.where(roroacms_term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)

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
    before_save :deal_with_structured_url
    after_save :deal_with_slug_update, on: :update

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


    def deal_with_structured_url
      path = self.path.pluck(:slug)
      path = path.push(self.slug) if self.id.blank?
      self.structured_url = "/" + path.join('/') if !path.blank?
    end

    def deal_with_slug_update
      if defined?(self.changes[:slug]) && !self.changes[:slug].blank?
        self.subtree.each do |f|
          self.structured_url = "/" + self.path.pluck(:slug).join('/')
          f.save
        end
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
      t = Term.joins(:term_anatomy).where(roroacms_term_anatomies: {taxonomy: type}).order('name')
      t = t.where.not(id: do_not_include) if !do_not_include.blank?
      t = t.arrange if do_arrange
      t
    end

    def self.get_records(type = 'tag', record = nil)
      rec = Term.joins(:term_anatomy).where(roroacms_term_anatomies: {taxonomy: type}).order('name')
      rec = rec.where.not(id: record) if !record.blank?
      rec.arrange
    end

    # If the has cover image has been removed this will be set to nothing and will update the cover image option agasint the admin
    # Params:
    # +has_cover+:: the has_cover parameter (string)

    def deal_with_cover(has_cover)
      self.cover_image = '' if defined?(has_cover) && has_cover.blank?
    end

  end
end