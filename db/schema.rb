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

ActiveRecord::Schema.define(:version => 20130407165825) do

  create_table "accounts", :force => true do |t|
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "api_keys", :force => true do |t|
    t.integer  "account_id",   :null => false
    t.string   "access_token", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "api_keys", ["access_token"], :name => "index_api_keys_on_access_token", :unique => true
  add_index "api_keys", ["account_id"], :name => "index_api_keys_on_account_id"

  create_table "event_lists", :force => true do |t|
    t.integer  "account_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_lists", ["account_id"], :name => "index_event_lists_on_account_id"

  create_table "events", :force => true do |t|
    t.integer  "account_id",    :null => false
    t.integer  "event_list_id", :null => false
    t.string   "name",          :null => false
    t.string   "description",   :null => false
    t.datetime "due_at",        :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "events", ["account_id"], :name => "index_events_on_account_id"
  add_index "events", ["event_list_id"], :name => "index_events_on_event_list_id"

end
