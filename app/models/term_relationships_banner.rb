class TermRelationshipsBanner < ActiveRecord::Base
  
  belongs_to :banner
  belongs_to :term

end
