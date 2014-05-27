class AddPostAdditionalDataToPosts < ActiveRecord::Migration
  def change
  	add_column :post, :post_additional_data, :text, :after => :post_visible
  end
end