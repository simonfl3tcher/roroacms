class AddComments < ActiveRecord::Migration
  def up
  	create_table :comments do |t|

  		t.integer :post_id          
  		t.string :author 		   
  		t.string :email     
  		t.string :website    
  		t.text :comment    
  		t.string :comment_approved    
  		t.integer :parent_id    
  		t.datetime :submitted_on
  		t.column :is_spam, "ENUM('Y', 'N')", :default => 'N'
  		t.string :ancestry
  		t.timestamps

  	end
  end

  def down
  	drop_table :comments
  end
end