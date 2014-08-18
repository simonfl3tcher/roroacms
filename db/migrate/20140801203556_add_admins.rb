class AddAdmins < ActiveRecord::Migration

   def self.up

    create_table(:roroacms_admins) do |t|
      t.string   "email",                            default: "",  null: false
      t.text     "password_digest"
      t.text     "description"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "username"
      t.string   "access_level"
      t.text     "avatar"
      t.text     "cover_picture"
      t.string   "overlord",                         limit: 1, default: "Y"
      t.string   "encrypted_password",               default: "",  null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                    default: 0,   null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "failed_attempts",                  default: 0,   null: false
      t.string   "unlock_token"
      t.datetime "locked_at"
      t.datetime "created_at",                                     null: false
      t.datetime "updated_at",                                     null: false
    end

    add_index "roroacms_admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
    add_index "roroacms_admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
    add_index "roroacms_admins", ["username"], name: "unique_username", unique: true, using: :btree
    
  end

  def self.down

    drop_table :roroacms_admins

  end

end
