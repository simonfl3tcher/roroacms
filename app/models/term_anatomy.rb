class TermAnatomy < ActiveRecord::Base
  has_one :term 
  attr_accessible :count, :description, :parent, :taxonomy, :term_id
end
