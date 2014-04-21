class TermRelationshipsBanner < ActiveRecord::Base
	# relations and validations
	belongs_to :banner
	belongs_to :term
end
