class PostAbstraction < ActiveRecord::Base
	belongs_to :post
  	attr_accessible :abstraction_key, :abstraction_value, :post_id
end
