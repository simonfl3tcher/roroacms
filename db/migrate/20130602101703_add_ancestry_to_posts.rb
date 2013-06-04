class AddAncestryToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :ancestry, :string
    add_index :posts, :ancestry
  end
  def self.down
    remove_column :posts, :ancestry
   	remove_index :posts, :ancestry
  end
end
