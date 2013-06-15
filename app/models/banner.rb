class Banner < ActiveRecord::Base

  has_many :term_relationships_banners, :dependent => :destroy
  has_many :terms, :through => :term_relationships_banners
  
  validates :name, :image, :presence => true

  BANNER_CATEGORIES = Term.where(term_anatomies: {taxonomy: 'banner'}).order('name asc').includes(:term_anatomy)
  
end
