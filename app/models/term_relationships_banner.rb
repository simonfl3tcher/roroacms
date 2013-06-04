class TermRelationshipsBanner < ActiveRecord::Base
  
  belongs_to :banner
  belongs_to :term

  attr_accessible :banner_id, :term_id

end
