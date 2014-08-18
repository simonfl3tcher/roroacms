class AddRoroacmsTermRelationships < ActiveRecord::Migration

	def self.up

    create_table(:roroacms_term_relationships) do |t|
      t.integer  "post_id"
	    t.integer  "term_id"
	    t.datetime "created_at", null: false
	    t.datetime "updated_at", null: false
    end

    add_index "roroacms_term_relationships", ["post_id"], name: "post_id", using: :btree
	    
	end

  def self.down

    drop_table :roroacms_term_relationships

  end


end
