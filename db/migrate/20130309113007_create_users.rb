class CreateUsers < ActiveRecord::Migration
  def change

  	create_table :users do |t|
  		t.string :email
  		t.string :password_digest
  		t.column :access_level, "ENUM('admin', 'customer')"
  		t.timestamps
  	end

  end
end
