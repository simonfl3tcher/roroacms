class Post < ActiveRecord::Base

  has_ancestry

  Rails.cache.clear 

  belongs_to :admin
  has_many :post_abstractions
  has_many :attachments

  has_many :term_relationships, :dependent => :destroy
  has_many :terms, :through => :term_relationships

  has_many :child, :class_name => "Post", :foreign_key => "parent_id", conditions: "post_type != 'autosave'"

  validates :post_title, :presence => true
  validates_uniqueness_of :post_slug, :scope => [:post_type]

  validates_format_of :post_slug, :with => /^[A-Za-z0-9-]*$/

  POST_STATUS = ["Published", "Draft", "Disabled"]

  
  POST_TAGS = Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)
  POST_CATEGORIES = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)

  scope :from_this_year, where("post_date > ? AND < ?", Time.now.beginning_of_year, Time.now.end_of_year)

  def self.setup_and_search_posts params, type
      
      posts = Post.where(:disabled => 'N', :post_type => type, ).order('post_date desc').page(params[:page]).per(Setting.get_pagination_limit)
      if params.has_key?(:search) && !params[:search].blank?
        posts = Post.where("(id like ? or post_title like ? or post_slug like ?) and disabled = 'N' and post_type = ? and post_status != 'Autosave'", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", type).page(params[:page]).per(Setting.get_pagination_limit)
      end

      return posts

  end

  def self.deal_with_categories post, cats, tags, del = false 

      @delcats = TermRelationship.where(:post_id => post.id)

      if del 
        if !@delcats.blank?
              @delcats.each do |f|

              @cat = TermRelationship.find(f.id)
              @cat.destroy

              end
          end
      end

      if !cats.blank?
          cats.each do |val|
          TermRelationship.create(:term_id => val, :post_id => post.id)
        end
      end
      if !tags.blank?
          tags.each do |val|
          TermRelationship.create(:term_id => val, :post_id => post.id)
        end
      end

  end

  def self.disable_post post_id

    post = Post.find(post_id)
    post.disabled = "Y"
    post.save

  end

  def self.deal_with_abnormalaties post 

    if post.post_slug.empty?
      post.post_slug = post.post_title.gsub(' ', '-').downcase
    end

    if post.post_status.blank?
      post.post_status = 'Draft'
    end

    return post

  end

  def self.do_autosave params, post

    parent = params[:post][:id]
    @autosave_records = Post.where("parent_id = ? and post_type = 'autosave'", parent).order("created_at DESC")

    if @autosave_records.length > 9
      Post.destroy(@autosave_records.last[:id])
    end
    
    # Do the autosave
    @cats = params[:category_ids]

    post.id = nil
    post.parent_id = params[:post][:id]

    if post.post_slug.empty?
      post.post_slug = post.post_title.gsub(' ', '-')
    end

      post.post_status = 'Autosave'
      post.post_type = 'autosave'

    if post.save(:validate => false)
      @delcats = TermRelationship.where(:post_id => post.id)

          if !@delcats.blank?
            @delcats.each do |f|

              @cat = TermRelationship.find(f.id)
            @cat.destroy

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
  end

  def self.restore post 

    parent = Post.find(post.parent_id)

    parent.post_content = post.post_content
    parent.post_date = post.post_date
    parent.post_name = post.post_name
    parent.post_slug = post.post_slug
    parent.post_title = post.post_title
    parent.disabled = post.disabled

    parent.save

    return parent.id

  end

  def self.bulk_update params, type

    action = params[:to_do]
    action = action.gsub(' ', '_')

    if type == 'pages'
      act = params[:pages]
    else
      act = params[:posts]
    end

    if act.nil?
      action = ""
    end

    case action.downcase 
      
      when "publish"
        bulk_update_publish act
            return "#{type.capitalize} were successfully published"
      when "draft"
        bulk_update_draft act
            return "#{type.capitalize} were successfully set to draft"
      when "move_to_trash"
        bulk_update_move_to_trash act
            return "#{type.capitalize} were successfully moved to trash"
      else
      
      respond_to do |format|
          return 'Nothing was done'
        end
    end

  end

  private 

  def self.bulk_update_publish params
    params.each do |val|
      post = Post.find(val)
      post.post_status = "Published"
      post.post_date = Time.now.utc.to_s(:db)
      post.save
    end
  end

  def self.bulk_update_draft params
    params.each do |val|
      post = Post.find(val)
      post.post_status = "Draft"
      post.save
    end 
  end

  def self.bulk_update_move_to_trash params
    params.each do |val|
      post = Post.find(val)
      post.disabled ="Y"
      post.save
    end
  end

end
