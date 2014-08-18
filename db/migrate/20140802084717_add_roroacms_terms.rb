class AddRoroacmsTerms < ActiveRecord::Migration

	def self.up

    create_table(:roroacms_terms) do |t|
      t.string   "name"
	    t.string   "slug"
	    t.text     "structured_url"
	    t.text     "description"
	    t.integer  "parent_id"
	    t.datetime "created_at",     null: false
	    t.datetime "updated_at",     null: false
	    t.text     "cover_image"
	    t.string   "ancestry"
    end

    add_index "roroacms_terms", ["ancestry"], name: "index_terms_on_ancestry", using: :btree
	    
	end

  def self.down

    drop_table :roroacms_terms

  end

end
