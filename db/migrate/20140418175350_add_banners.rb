class AddBanners < ActiveRecord::Migration
  def up
  	create_table :banners do |t|

  		t.string :name
  		t.string :image
  		t.text :description
  		t.string :sort_order

  		t.timestamps

  	end
  end

  def down
  	drop_table :banners
  end
end