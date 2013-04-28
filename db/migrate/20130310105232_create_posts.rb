class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :post_author
      t.datetime :post_date
      t.text :post_content, limit: 4294967295
      t.text :post_title
      t.string :post_status
      t.string :post_name
      t.integer :post_parent
      t.string :post_type
      t.text :post_slug
      t.timestamps
    end
  end
end
