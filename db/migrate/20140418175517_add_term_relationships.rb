class AddTermRelationships < ActiveRecord::Migration
  def up
  	create_table :term_relationships do |t|
      
  		t.integer :post_id, :limit => 100
  		t.integer :term_id, :limit => 11
  		t.timestamps

  	end
  end

  def down
  	drop_table :term_relationships
  end
end