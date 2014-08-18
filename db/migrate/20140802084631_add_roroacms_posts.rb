class AddRoroacmsPosts < ActiveRecord::Migration

	def self.up

    create_table(:roroacms_posts) do |t|
      t.integer  "admin_id"
	    t.datetime "post_date"
	    t.text     "post_content"
	    t.text     "post_title"
	    t.text     "cover_image"
	    t.string   "post_status"
	    t.string   "post_template"
	    t.integer  "parent_id"
	    t.string   "post_type"
	    t.text     "post_slug"
	    t.string   "post_visible",                   default: "Y"
	    t.text     "post_additional_data"
	    t.integer  "sort_order"
	    t.datetime "created_at",                                   null: false
	    t.datetime "updated_at",                                   null: false
	    t.string   "disabled",             limit: 1, default: "N"
	    t.string   "post_seo_title"
	    t.text     "post_seo_description"
	    t.string   "post_seo_is_disabled",           default: "N"
	    t.string   "post_seo_no_index",              default: "N"
	    t.string   "post_seo_no_follow",             default: "N"
	    t.string   "ancestry"
	    t.text     "structured_url"
    end

   	add_index "roroacms_posts", ["ancestry"], name: "index_posts_on_ancestry", using: :btree
	    
	end

  def self.down

    drop_table :roroacms_posts

  end


end
