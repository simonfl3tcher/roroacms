class AddAncestryToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :ancestry, :string
    add_index :terms, :ancestry
  end
end
