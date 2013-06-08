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

ActiveRecord::Schema.define(:version => 20130604145308) do

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

  create_table "reminders", :force => true do |t|
    t.integer  "event_id",    :null => false
    t.datetime "reminded_at", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "reminders", ["event_id"], :name => "index_reminders_on_event_id"

  create_table "requests", :force => true do |t|
    t.integer  "account_id", :null => false
    t.integer  "api_key_id", :null => false
    t.string   "ip_address", :null => false
    t.string   "url",        :null => false
    t.string   "http_verb",  :null => false
    t.text     "params"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "requests", ["account_id"], :name => "index_requests_on_account_id"
  add_index "requests", ["api_key_id"], :name => "index_requests_on_api_key_id"

  create_table "responses", :force => true do |t|
    t.integer  "account_id"
    t.integer  "status",       :null => false
    t.string   "content_type", :null => false
    t.text     "body",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "responses", ["account_id"], :name => "index_responses_on_account_id"

  create_table "subscribers", :force => true do |t|
    t.integer  "account_id",   :null => false
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "subscribers", ["account_id"], :name => "index_subscribers_on_account_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "event_list_id", :null => false
    t.integer  "subscriber_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "account_id",    :null => false
  end

  add_index "subscriptions", ["account_id"], :name => "index_subscriptions_on_account_id"
  add_index "subscriptions", ["event_list_id"], :name => "index_subscriptions_on_event_list_id"
  add_index "subscriptions", ["subscriber_id"], :name => "index_subscriptions_on_subscriber_id"

end
