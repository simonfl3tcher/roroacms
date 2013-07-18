class AddAdmin < ActiveRecord::Migration
  def up
  	Admin.create :username => APP_CONFIG['admin_username'], :password => APP_CONFIG['admin_password'], :email => APP_CONFIG['admin_email'], :access_level => 'admin', :first_name => '', :last_name => ''
  end
end
