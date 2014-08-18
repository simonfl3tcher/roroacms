module Roroacms 
  class Post < ActiveRecord::Base

    include GeneralHelper
    include MediaHelper

    ## misc ##

    has_ancestry :orphan_strategy => :adopt 
    attr_accessor :skip_slug_uniqueness

    ## constants ##

    POST_STATUS = ["Published", "Draft", "Disabled"]

    ## associations ##

    belongs_to :admin
    has_many :post_abstractions
    has_many :attachments
    has_many :term_relationships, :dependent => :destroy
    has_many :terms, :through => :term_relationships

    ## validations ##

    validates :post_title, :post_slug, :presence => true
    validates_uniqueness_of :post_slug, :scope => [:post_type], unless: :skip_slug_uniqueness
    validates_format_of :post_slug, :with => /\A[A-Za-z0-9-]*\z/
    validates :sort_order, :numericality => true, :allow_blank => true

    ## named scopes ##

    scope :from_this_year, -> { where("post_date > ? AND post_date < ?", Time.now.beginning_of_year, Time.now.end_of_year) }


    ## callbacks ##

    before_validation :deal_with_abnormalaties
    after_update :create_user_backup_record, on: :update
    before_save :deal_with_structured_url
    after_save :deal_with_slug_update, on: :update


    ## methods ##

    # get all the posts/pages in the system - however if there is a search parameter
    # search the necessary fields for the given value
    # Params:
    # +params+:: all parameters
    # +type+:: define a post type

    def self.setup_and_search_posts(params, type)
      type = type == 'page' ? 'page' : 'post'
      if type == 'page'
        posts = Post.where("disabled ='N' and post_type = ?", type).order("post_title").arrange
      else
        posts = Post.where("disabled ='N' and post_type = ?", type).order("post_title")
      end
      posts

    end

    # get all the tags/categories for the system
    # Params:
    # +type+:: define a term type
    # +id+:: ID of the term you want to retur

    def self.get_terms(type = 'category', id = nil)
      sql = Term.where(roroacms_term_anatomies: {taxonomy: type})
      sql = sql.where('terms.id != ?', id) if !id.blank?
      sql.order('name asc').includes(:term_anatomy)
    end

    # gets called when a post gets saved to add categories/tags against the post
    # Params:
    # +post+:: post ID
    # +cats+:: all the category params
    # +tags+:: all the tags params
    # +delete+:: boolean as to wether to remove the current relations to tag and categories

    def self.deal_with_categories(post, cats, tags, delete = false)

      @delcats = TermRelationship.where(:post_id => post.id)

      # if delete is true it will remove all relationships with that individual post

      if delete && !@delcats.blank?
        @delcats.each do |f|
          TermRelationship.where(:id => f.id).destroy_all
        end
      end

      # if categories is not blank it will create a new relationship with that post

      if !cats.blank?
        cats.each do |val|
          TermRelationship.create(:term_id => val, :post_id => post.id)
        end
      end

      # if tags is not blank it will create a new relationship with that post

      if !tags.blank?
        tags.each do |val|
          TermRelationship.create(:term_id => val, :post_id => post.id)
        end
      end

    end

    def deal_with_structured_url
      path = self.path.pluck(:post_slug)
      path = path.push(self.post_slug) if self.id.blank?
      self.structured_url = "/" + path.join('/') if !path.blank?
    end

    # disables the post essentially putting it into the trash area
    # Params:
    # +post_id+:: post ID

    def self.disable_post(post_id)
      post = Post.find(post_id)
      post.disabled = "Y"
      post.save(validate: false)
    end

    # will make sure that specific data is correctly formatted for the database

    def deal_with_abnormalaties
      self.cover_image = upload_images(cover_image, post_type.to_s + '/' + id.to_s, 'posts') if cover_image.class != String && cover_image.class != NilClass
      # if the slug is empty it will take the title and create a slug
      self.post_slug = 
        if post_slug.blank?
          post_title.gsub(' ', '-').downcase.gsub(/[^a-z0-9\-\s]/i, '')
        else
          post_slug.gsub(' ', '-').downcase.gsub(/[^a-z0-9\-\s]/i, '')
        end

      # if post status is left blank it will set the status to draft
      self.post_status = 'Draft' if post_status.blank?

      # if the post has a parent it will prefix the structured url with its parents url
      self.structured_url = 
        if parent_id
          "#{parent.structured_url}/#{post_slug}"
        else
          "/#{post_slug}"
        end

    end

    # filter/format the additional fields and add the data to the post_additional_data field of the record.
    # Params:
    # +data+:: array of additional fields

    def additional_data(data = '')

      # abort data.inspect

      if !data.blank?
        data.each do |key, value|
          data[key.to_sym] = value[0] if value.size < 2
        end
        self.post_additional_data = ActiveSupport::JSON.encode(data)
      else
        self.post_additional_data = ''
      end

    end

    # creates a revision record of the post
    # Params:
    # +params+:: the parameters
    # +post+:: the post that you want to create an autosave for

    def self.do_autosave(params, post)

      parent = Post.find(params[:post][:id])
      @autosave_records = Post.where("ancestry = '?' AND post_type = 'autosave' AND post_status = 'Autosave'", parent.id).order("created_at DESC")

      if (remove_uncessary(post) != remove_uncessary(parent)) && (remove_uncessary(post) != remove_uncessary(@autosave_records.first))

        # if the amount of records is equal to 10 remove the last one
        Post.destroy(@autosave_records.last[:id]) if @autosave_records.length > 9

        # Do the autosave
        @cats = params[:category_ids]

        # create the settings for the revision record

        post.id = nil
        post.parent_id = parent.id

        post.post_slug = post.post_title.gsub(' ', '-') if post.post_slug.empty?

        post.post_status = 'Autosave'
        post.post_type = 'autosave'

        # save the post and its categories/tags
        if post.save(:validate => false)

          @delcats = TermRelationship.where(:post_id => post.id)

          if !@delcats.blank?
            @delcats.each do |f|
              @cat = TermRelationship.where(:id => f.id).destroy_all
            end
          end

          if !@cats.blank?
            @cats.each do |val|
              TermRelationship.create(:term_id => val, :post_id => post.id)
            end
          end

          return "passed"

        else
          return "failed"
        end

      else
        return "nothing changed"
      end

    end

    def create_user_backup_record

      if self.post_slug_changed? || self.post_content_changed? || self.post_title_changed?

        post = self.attributes
        post['parent_id'] = post['id']
        post['structured_url'] = nil
        post['updated_at'] = nil
        post['created_at'] = nil
        post['id'] = nil
        post.delete('ancestry')


        if post['post_slug'].blank?
          post['post_slug'] = post['post_title'].gsub(' ', '-')
        end

        post['post_status'] = 'User-Autosave'
        post['post_type'] = 'autosave'

        begin
          Post.new(post.symbolize_keys).save(validate: false) and return true
        rescue
          abort "Error #{$!}".inspect
        end

      end

    end

    def deal_with_slug_update
      if defined?(self.changes[:post_slug]) && !self.changes[:post_slug].blank?
        self.subtree.each do |f|
          self.structured_url = "/" + self.path.pluck(:post_slug).join('/')
          f.save
        end
      end
    end


    # remove the unwanted keys from the hash to be able to successfully compare the hashes
    # Params:
    # +obj+:: the object to remove the keys from

    def self.remove_uncessary(obj)
      o = obj
      if !o.blank?
        # o.post_content = o.post_content.gsub("\n", ' ').gsub("\r", ' ').squeeze(' ')
        o.post_additional_data = "" if o.post_additional_data.blank?
        o.cover_image = "" if o.cover_image.blank?
        o = o.attributes
        o.delete('id')
        o.delete('created_at')
        o.delete('updated_at')
        o.delete('ancestry')
        o.delete('structured_url')
        o.delete('post_visible')
        o.delete('post_status')
        o.delete('post_type')
        o.delete('parent_id')
      end

      o

    end

    # restore the given post back to the revision record data
    # Params:
    # +post+:: the post autosave record that you want to restore the current post to 

    def self.restore(post)

      parent = Post.find(post.parent_id)

      parent.post_content = post.post_content
      parent.post_date = post.post_date
      parent.post_slug = post.post_slug
      parent.post_title = post.post_title
      parent.disabled = post.disabled

      parent.save

      return parent

    end

    # is the bootstrap for the bulk update function. It takes in the call
    # and decides what function to call in order to get the correct output
    # Params:
    # +params+:: the parameters
    # +type+:: wether it is pages or posts you want to use


    def self.bulk_update(params, type)

      action = params[:to_do]
      action = action.gsub(' ', '_')

      act = 
        if type == 'pages'
          params[:pages]
        else
          params[:posts]
        end

      action = "" if act.nil?

      case action.downcase

      when "publish"

        # update all of the given records to have a post_status of published
        Post.where(:id => act).update_all(:post_status => "Published", :post_date => Time.now.utc.to_s(:db))
        return I18n.t("models.post.bulk_update.published_successfully", type: type.capitalize)

      when "draft"

        # update all of the given records to have a post_status of draft
        Post.where(:id => act).update_all(:post_status => "Draft")
        return I18n.t("models.post.bulk_update.draft_successfully", type: type.capitalize)

      when "move_to_trash"

        # move all of the given records into the trash
        Post.where(:id => act).update_all(:disabled => "Y")
        return I18n.t("models.post.bulk_update.trash_successfully", type: type.capitalize)

      else

        respond_to do |format|
          return I18n.t("generic.nothing")
        end

      end

    end

    # If the has cover image has been removed this will be set to nothing and will update the cover image option agasint the admin
    # Params:
    # +has_cover+:: the has_cover parameter (string)

    def deal_with_cover(has_cover)
      self.cover_image = '' if defined?(has_cover) && has_cover.blank?
    end

    def self.parent_records(record)
      rec = Post.where("disabled ='N' and post_type = 'page'").order("post_title")
      rec = rec.where.not(id: record) if !record.blank?
      rec.arrange

    end

  end
end