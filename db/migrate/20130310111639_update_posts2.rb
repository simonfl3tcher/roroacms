class UpdatePosts2 < ActiveRecord::Migration
  def up
  	rename_column :posts, :users_id, :admins_id
  end

  def down
  end
end
