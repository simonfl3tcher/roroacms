class CreateUsersUpdate < ActiveRecord::Migration
  def change
  	add_column :users, :access_level, :int
  end
end
