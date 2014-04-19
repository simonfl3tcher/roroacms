class AddMenuOptions < ActiveRecord::Migration
  def up
  	create_table :menu_options do |t|

  		t.integer :menu_id          
  		t.integer :option_id          
  		t.integer :parent_id          
  		t.string :data_type 		   
  		t.integer :lft     
  		t.integer :rgt    
  		t.string :label    
  		t.text :custom_data    
  		t.timestamps

  	end
  end

  def down
  	drop_table :menu_options
  end
end