class AddMenuOptions < ActiveRecord::Migration
 def self.up
    create_table :menuOptions do |t|
      t.string :menuid
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
    end
  end

  def self.down
    drop_table :menuOptions
  end
end
