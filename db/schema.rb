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

ActiveRecord::Schema.define(:version => 20130416182556) do

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
  end

  create_table "attachments", :force => true do |t|
    t.integer  "post_id"
    t.text     "attachment_name"
    t.text     "attachment_content"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "post_abstractions", :force => true do |t|
    t.integer  "posts_id"
    t.string   "abstraction_key"
    t.text     "abstraction_value"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "admin_id"
    t.datetime "post_date"
    t.text     "post_content",         :limit => 2147483647
    t.text     "post_title"
    t.string   "post_status"
    t.string   "post_name"
    t.integer  "post_parent"
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
  end

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
    t.text     "description"
    t.integer  "parent"
    t.integer  "count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "term_relationships", :force => true do |t|
    t.integer  "post_id"
    t.integer  "term_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "term_relationships", ["post_id"], :name => "post_id"

  create_table "terms", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "term_group", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "website"
  end

end
