class AddTerms < ActiveRecord::Migration
  def up
  	create_table :terms do |t|
      
  		t.string :name, :limit => 255
  		t.string :slug, :limit => 255
  		t.text :description
  		t.timestamps

  	end
  end

  def down
  	drop_table :terms
  end
end