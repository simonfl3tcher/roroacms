class RemoveContactForm < ActiveRecord::Migration
  def up
  	drop_table :contact_forms
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
