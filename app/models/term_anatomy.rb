class TermAnatomy < ActiveRecord::Base
  belongs_to :term 
  attr_accessible :count, :parent, :taxonomy, :term_id
end
