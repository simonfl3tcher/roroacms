class AlterTermsTable < ActiveRecord::Migration
  def change
  	rename_column :terms, :parent, :parent_id
  end
end
