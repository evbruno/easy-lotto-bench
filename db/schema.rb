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

ActiveRecord::Schema.define(version: 20160815210343) do

  create_table "draws", force: :cascade do |t|
    t.integer  "number"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "draws", ["game_id"], name: "index_draws_on_game_id"

  create_table "games", force: :cascade do |t|
    t.date     "draw_date"
    t.integer  "lottery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "games", ["lottery_id"], name: "index_games_on_lottery_id"

  create_table "lotteries", force: :cascade do |t|
    t.string   "name"
    t.string   "abbrev"
    t.string   "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prizes", force: :cascade do |t|
    t.integer  "hits"
    t.float    "value"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "prizes", ["game_id"], name: "index_prizes_on_game_id"

end
