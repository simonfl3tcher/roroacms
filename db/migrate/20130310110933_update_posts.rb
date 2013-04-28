class UpdatePosts < ActiveRecord::Migration
  def up
  	rename_column :posts, :post_author, :users_id
  end

  def down
  end
end
