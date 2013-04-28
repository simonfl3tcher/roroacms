class CreatePostAbstractions < ActiveRecord::Migration
  def change
    create_table :post_abstractions do |t|
      t.integer :posts_id
      t.string :abstraction_key
      t.text :abstraction_value

      t.timestamps
    end
  end
end
