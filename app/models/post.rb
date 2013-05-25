class Post < ActiveRecord::Base
  
  belongs_to :admin
  has_many :post_abstractions
  has_many :attachments

  has_many :term_relationships, :dependent => :destroy
  has_many :terms, :through => :term_relationships

  has_many :child, :class_name => "Post", :foreign_key => "post_parent", conditions: "post_type != 'autosave'"

  attr_accessible :admin_id, :post_content, :post_date, :post_name, :post_parent, :post_slug, :post_status, :post_title, :post_type, :disabled, :post_seo_title, :post_seo_description, :post_seo_keywords, :post_seo_is_disabled, :post_seo_no_follow, :post_seo_no_index

  validates :post_title, :presence => true
  validates_uniqueness_of :post_slug, :scope => [:post_type]

  validates_format_of :post_slug, :with => /^[A-Za-z0-9-]*$/

  POST_STATUS = ["Published", "Draft", "Disabled"]

  POST_TAGS =   Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)

  POST_CATEGORIES = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)

  scope :from_this_year, where("post_date > ? AND < ?", Time.now.beginning_of_year, Time.now.end_of_year)

end
