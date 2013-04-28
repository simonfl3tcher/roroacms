class Attachment < ActiveRecord::Base
  
  belongs_to :post

  attr_accessible :post_id, :attachment_name, :attachment_content
  
end
