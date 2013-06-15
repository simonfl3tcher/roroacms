class Post < ActiveRecord::Base

  has_ancestry

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

  Rails.cache.clear 
  POST_TAGS =   Term.where(term_anatomies: {taxonomy: 'tag'}).order('name asc').includes(:term_anatomy)
  Rails.cache.clear 
  POST_CATEGORIES = Term.where(term_anatomies: {taxonomy: 'category'}).order('name asc').includes(:term_anatomy)

  scope :from_this_year, where("post_date > ? AND < ?", Time.now.beginning_of_year, Time.now.end_of_year)

end
