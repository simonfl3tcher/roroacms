class AddRoroacmsMenuOptions < ActiveRecord::Migration
  
  def self.up

    create_table(:roroacms_menu_options) do |t|
      t.integer "menu_id"
	    t.integer "option_id"
	    t.integer "parent_id"
	    t.string  "data_type"
	    t.integer "lft"
	    t.integer "rgt"
	    t.string  "label"
	    t.text    "custom_data"
    end
	    
	end

  def self.down

    drop_table :roroacms_menu_options

  end

end
