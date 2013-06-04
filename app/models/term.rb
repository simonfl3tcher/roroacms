class Term < ActiveRecord::Base

	has_many :term_relationships
	has_many :term_relationships_banners
	
	has_many :posts, :through => :term_relationships
	has_many :banners, :through => :term_relationships_banners

	has_one :term_anatomy, :dependent => :destroy

  	attr_accessible :name, :slug, :description, :term_group

  	validates :name, :presence => true
end
