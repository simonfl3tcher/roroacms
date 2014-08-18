class AddRoroacmsComments < ActiveRecord::Migration
  	
  def self.up

    create_table(:roroacms_comments) do |t|
      t.integer  "post_id"
	    t.text     "author"
	    t.text     "email"
	    t.text     "website"
	    t.text     "comment"
	    t.text     "comment_approved"
	    t.text     "parent_id"
	    t.datetime "submitted_on"
	    t.datetime "created_at",                               null: false
	    t.datetime "updated_at",                               null: false
	    t.string   "is_spam",          limit: 1, default: "N"
	    t.string   "ancestry"
    end

    add_index "roroacms_comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
	    
	end

  def self.down

    drop_table :roroacms_comments

  end


end
