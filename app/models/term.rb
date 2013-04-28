class Term < ActiveRecord::Base

	has_many :term_relationships
	has_many :posts, :through => :term_relationships

	has_one :term_anatomy

  	attr_accessible :name, :slug, :term_group

  	validates :name, :presence => true
end
