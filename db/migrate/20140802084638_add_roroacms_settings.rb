class AddRoroacmsSettings < ActiveRecord::Migration

	def self.up

    create_table(:roroacms_settings) do |t|
      t.string   "setting_name"
	    t.text     "setting"
	    t.string   "type_of_setting", limit: 11
	    t.datetime "created_at",                 null: false
	    t.datetime "updated_at",                 null: false
    end
	    
	end

  def self.down

    drop_table :roroacms_settings

  end

end
