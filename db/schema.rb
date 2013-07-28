# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "access_level",    :limit => 6
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "avatar"
    t.string   "inline_editing",  :limit => 1, :default => "Y"
    t.string   "overlord",        :limit => 1, :default => "N"
    t.text     "description"
  end

  create_table "banners", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description"
    t.string   "sort_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.text     "author"
    t.text     "email"
    t.text     "website"
    t.text     "comment"
    t.text     "comment_approved"
    t.text     "parent_id"
    t.datetime "submitted_on"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "is_spam",          :limit => 1, :default => "N"
    t.string   "ancestry"
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"

  create_table "menu_options", :force => true do |t|
    t.integer  "menu_id"
    t.integer "option_id"
    t.integer "parent_id"
    t.string  "data_type"
    t.integer "lft"
    t.integer "rgt"
    t.string  "label"
    t.text    "custom_data"
  end

  create_table "menus", :force => true do |t|
    t.string "name"
    t.string "key"
  end

  create_table "posts", :force => true do |t|
    t.integer  "admin_id"
    t.datetime "post_date"
    t.text     "post_content"
    t.text     "post_title"
    t.string   "post_status"
    t.string   "post_template"
    t.string   "post_name"
    t.integer  "parent_id"
    t.string   "post_type"
    t.text     "post_slug"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.string   "disabled",             :limit => 1,          :default => "N"
    t.string   "post_seo_title"
    t.text     "post_seo_description"
    t.string   "post_seo_is_disabled",                       :default => "N"
    t.string   "post_seo_no_index",                          :default => "N"
    t.string   "post_seo_no_follow",                         :default => "N"
    t.string   "ancestry"
    t.text     "structured_url"
  end

  add_index "posts", ["ancestry"], :name => "index_posts_on_ancestry"

  create_table "settings", :force => true do |t|
    t.string   "setting_name"
    t.text     "setting"
    t.string   "type_of_setting", :limit => 11
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "term_anatomies", :force => true do |t|
    t.integer  "term_id"
    t.string   "taxonomy"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "term_relationships", :force => true do |t|
    t.integer  "post_id"
    t.integer  "term_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "term_relationships", ["post_id"], :name => "post_id"

  create_table "term_relationships_banners", :force => true do |t|
    t.integer  "banner_id"
    t.integer  "term_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
