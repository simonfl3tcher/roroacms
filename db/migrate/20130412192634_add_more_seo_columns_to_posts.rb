class AddMoreSeoColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_seo_no_follow, :string
  end
end
