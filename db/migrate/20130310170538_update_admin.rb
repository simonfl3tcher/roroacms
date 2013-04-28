class UpdateAdmin < ActiveRecord::Migration
  def up
  	add_column :admins, :avatar, :string
  end

  def down
  end
end
