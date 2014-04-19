class AddPosts < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
      
  		t.integer :admin_id 		     
  		t.datetime :post_date    
  		t.text :post_content    
  		t.text :post_title    
  		t.string :post_status    
  		t.string :post_template    
  		t.string :post_name    
  		t.integer :parent_id    
  		t.string :post_type    
  		t.text :post_slug   

  		t.column :disabled, "ENUM('Y', 'N')", :default => 'N'
  		t.string :post_seo_title
  		t.text :post_seo_description
  		t.string :post_seo_is_disabled, :default => 'N'
  		t.string :post_seo_no_index, :default => 'N'
  		t.string :post_seo_no_follow, :default => 'N'
  		t.string :ancestry
  		t.text :structured_url

  		t.timestamps

  	end
  end

  def down
  	drop_table :posts
  end
end