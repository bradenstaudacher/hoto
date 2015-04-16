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

ActiveRecord::Schema.define(version: 20150414235702) do

  create_table "games", force: true do |t|
    t.string   "turnstate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games_players", force: true do |t|
    t.integer "games_id"
    t.integer "players_id"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.string   "colour"
    t.integer  "games_played"
    t.integer  "games_won"
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
