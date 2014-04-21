class TermRelationship < ActiveRecord::Base
	# relations and validations
	belongs_to :post
	belongs_to :term
end
