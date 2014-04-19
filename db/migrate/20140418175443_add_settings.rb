class AddSettings < ActiveRecord::Migration
  def up
  	create_table :settings do |t|
      
  		t.string :setting_name
  		t.text :string
  		t.string :type_of_setting, :limit => 11

  		t.timestamps

  	end
  end

  def down
  	drop_table :settings
  end
end