class AddImagesToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :cover_picture, :text, :after => :avatar
  end
end
