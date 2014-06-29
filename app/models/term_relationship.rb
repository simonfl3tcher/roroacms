class TermRelationship < ActiveRecord::Base
	
	## associations ##

	belongs_to :post
	belongs_to :term
	
end
