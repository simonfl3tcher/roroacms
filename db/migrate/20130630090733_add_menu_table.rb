class AddMenuTable < ActiveRecord::Migration
 def self.up
    create_table :menus do |t|
      t.string :name
      t.string :key
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end
  end

  def self.down
    drop_table :menus
  end
end
