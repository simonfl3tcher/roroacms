class TermRelationship < ActiveRecord::Base
  
  belongs_to :post
  belongs_to :term

  attr_accessible :post_id, :term_id

end
