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

ActiveRecord::Schema.define(:version => 20121019173946) do

  create_table "bottles", :force => true do |t|
    t.integer  "bottle_id"
    t.integer  "grape_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "available"
    t.datetime "availability_change_date"
    t.string   "availability_change_message"
    t.integer  "winery_id"
    t.string   "vintage",                     :limit => 4
    t.string   "drink_by_year",               :limit => 4
    t.string   "vineyard"
    t.string   "name"
    t.string   "cellar_location",             :limit => 30
    t.float    "price"
  end

  add_index "bottles", ["grape_id"], :name => "index_bottles_on_grape_id"

  create_table "grapes", :force => true do |t|
    t.string   "name",        :limit => 100, :null => false
    t.string   "color",       :limit => 10,  :null => false
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "wineries", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "country",      :null => false
    t.string   "location1",    :null => false
    t.string   "location2"
    t.string   "location3"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "winery_url"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
