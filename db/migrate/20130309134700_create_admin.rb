class CreateAdmins < ActiveRecord::Migration
  def change

  	create_table :admins do |t|
  		t.string :email
  		t.string :password
  		t.string :first_name
  		t.string :last_name
  		t.string :username
  		t.column :access_level, "ENUM('admin', 'editor', 'author')"
  		t.timestamps
  	end
  end
end
