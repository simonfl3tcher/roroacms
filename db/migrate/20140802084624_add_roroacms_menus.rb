class AddRoroacmsMenus < ActiveRecord::Migration

	def self.up

    create_table(:roroacms_menus) do |t|
      t.string "name"
	    t.string "key"
    end
	    
	end

  def self.down

    drop_table :roroacms_menus

  end

end
