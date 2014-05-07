class AddPostImageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :post_image, :text, :after => :post_title
  end
end
