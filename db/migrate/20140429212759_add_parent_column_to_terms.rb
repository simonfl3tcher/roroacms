class AddParentColumnToTerms < ActiveRecord::Migration

  def change
  	add_column :terms, :parent, :integer, default: 0
  end

  def down
  	remove_column :terms, :parent, :integer, default: 0
  end

end
