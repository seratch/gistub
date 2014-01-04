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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20121015023421) do

  create_table "comments", force: true do |t|
    t.integer  "gist_id",    null: false
    t.integer  "user_id",    null: false
    t.text     "body",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "gist_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gist_files", force: true do |t|
    t.string   "name",            null: false
    t.text     "body",            null: false
    t.integer  "gist_history_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gist_histories", force: true do |t|
    t.integer  "gist_id",    null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gists", force: true do |t|
    t.string   "title",          null: false
    t.boolean  "is_public",      null: false
    t.integer  "user_id"
    t.integer  "source_gist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.string   "omniauth_provider", null: false
    t.string   "omniauth_uid",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
