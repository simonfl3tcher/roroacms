class AddContactForms < ActiveRecord::Migration
  def up
  	create_table :contact_forms do |t|
  		t.string :name,               :null => false, :default => ""
  		t.text :message,              :null => false, :default => ""
  		t.string :email,              :null => false, :default => ""
  		t.string :subject,            :null => false, :default => ""
  	end
  end

  def down
  	drop_table :contact_forms
  end
end
