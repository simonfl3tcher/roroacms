class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.text :author
      t.text :email
      t.text :website
      t.text :comment
      t.text :comment_approved
      t.text :comment_parent
      t.timestamps
    end
  end
end
