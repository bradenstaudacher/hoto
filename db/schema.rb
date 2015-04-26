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

ActiveRecord::Schema.define(version: 20150426201504) do

  create_table "games", force: true do |t|
    t.string   "turnstate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        default: true
    t.string   "phase"
    t.integer  "moves_counter", default: 0
    t.integer  "winner_id"
    t.integer  "loser_id"
  end

  create_table "games_users", force: true do |t|
    t.integer "game_id"
    t.integer "user_id"
    t.string  "colour"
    t.integer "previous_rating"
  end

  create_table "squares", force: true do |t|
    t.integer  "x"
    t.integer  "y"
    t.string   "colour"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  add_index "squares", ["game_id"], name: "index_squares_on_game_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "games_played",    default: 0
    t.integer  "games_won",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "current_rating",  default: 1000
    t.string   "password_digest"
  end

end
