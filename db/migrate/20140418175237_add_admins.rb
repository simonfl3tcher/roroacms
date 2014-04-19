class AddAdmins < ActiveRecord::Migration

  def up
  	create_table :admins do |t|

  		t.string :email
  		t.text :password_digest
  		t.text :description
  		
  		t.string :first_name
  		t.string :last_name
  		t.string :username
  		t.string :access_level
  		t.string :avatar
  		
  		t.column :access_level, "ENUM('admin', 'editor')"
  		t.column :inline_editing, "ENUM('Y', 'N')", :default => 'Y'
  		t.column :overlord, "ENUM('Y', 'N')", :default => 'Y'

  		t.timestamps

  	end
  end

  def down
  	drop_table :admins
  end

end