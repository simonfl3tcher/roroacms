class AddSeoColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_seo_title, :string
    add_column :posts, :post_seo_description, :text
    add_column :posts, :post_seo_keywords, :string
    add_column :posts, :post_seo_is_active, :string

  end
end
