class CreateTermsAnatomies < ActiveRecord::Migration
  def change
    create_table :terms_anatomies do |t|
      t.integer :terms_id
      t.string :taxonomy
      t.text :description
      t.integer :parent
      t.integer :count

      t.timestamps
    end
  end
end
