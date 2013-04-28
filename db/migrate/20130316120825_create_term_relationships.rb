class CreateTermRelationships < ActiveRecord::Migration
  def change
    create_table :term_relationships do |t|
      t.integer :posts_id
      t.integer :terms_id

      t.timestamps
    end
  end
end
