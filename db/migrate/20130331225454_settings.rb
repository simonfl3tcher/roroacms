class Settings < ActiveRecord::Migration
  def up
  	 create_table :settings do |t|
      t.string :setting_name
      t.text :setting
      t.timestamps
    end
  end

  def down
  	drop_table :settings
  end
end
