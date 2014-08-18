class AddRoroacmsTermAnatomies < ActiveRecord::Migration
	
	def self.up

    create_table(:roroacms_term_anatomies) do |t|
      t.integer  "term_id"
	    t.string   "taxonomy"
	    t.datetime "created_at", null: false
	    t.datetime "updated_at", null: false
    end
	    
	end

  def self.down

    drop_table :roroacms_term_anatomies

  end

end
