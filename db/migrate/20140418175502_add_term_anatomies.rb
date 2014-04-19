class AddTermAnatomies < ActiveRecord::Migration
  def up
  	create_table :term_anatomies do |t|
      
  		t.integer :term_id, :limit => 11
  		t.string :taxonomy, :limit => 255
  		t.timestamps

  	end
  end

  def down
  	drop_table :term_anatomies
  end
end