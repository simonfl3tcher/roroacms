class AlterPostsTable < ActiveRecord::Migration
  def change
  	rename_column :posts, :post_image, :cover_image
  end
end
