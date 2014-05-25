class AddDeviseToAdmins < ActiveRecord::Migration
  def self.up
    create_table(:admins) do |t|
      ## Database authenticatable

      t.string :email,              null: false, default: ""
      t.text :password_digest
      t.text :description
      
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :access_level
      t.string :avatar
      
      t.column :access_level, "ENUM('admin', 'editor')"
      t.column :overlord, "ENUM('Y', 'N')", :default => 'Y'

      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at


      # Uncomment below if timestamps were not included in your original model.
      t.timestamps
    end

    add_index :admins, :email,                unique: true
    add_index :admins, :reset_password_token, unique: true
    
  end

  def self.down
    drop_table :admins
  end
end
