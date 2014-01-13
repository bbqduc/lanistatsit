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

ActiveRecord::Schema.define(version: 20140113123522) do

  create_table "heros", force: true do |t|
    t.string   "name"
    t.integer  "heroid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_name"
  end

  add_index "heros", ["heroid"], name: "index_heros_on_heroid", unique: true

  create_table "laniheros", force: true do |t|
    t.integer  "hero_id"
    t.integer  "player_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_participations", force: true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.integer  "kills"
    t.integer  "assists"
    t.integer  "deaths"
    t.integer  "finishgold"
    t.integer  "goldspent"
    t.integer  "lasthits"
    t.integer  "denies"
    t.integer  "gpm"
    t.integer  "xpm"
    t.integer  "herodamage"
    t.integer  "towerdamage"
    t.integer  "herohealing"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hero_id"
    t.float    "tfc",         default: 0.0
    t.boolean  "radiant"
    t.boolean  "win"
  end

  create_table "matches", force: true do |t|
    t.integer  "matchid"
    t.integer  "towerstatus_radiant"
    t.integer  "towerstatus_dire"
    t.integer  "barracksstatus_radiant"
    t.integer  "barracksstatus_dire"
    t.integer  "firstbloodtime"
    t.string   "gamemode"
    t.boolean  "radiant_win"
    t.integer  "duration"
    t.datetime "starttime"
    t.string   "replayurl"
    t.integer  "tapiplayers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tapiwin"
    t.integer  "kills",                  default: 0
    t.integer  "avg_gpm",                default: 0
  end

  add_index "matches", ["matchid"], name: "index_matches_on_matchid", unique: true

  create_table "matches_players", id: false, force: true do |t|
    t.integer "match_id",  null: false
    t.integer "player_id", null: false
  end

  create_table "players", force: true do |t|
    t.integer  "accountid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_matches",     default: 0
    t.integer  "sum_gold",        default: 0
    t.integer  "sum_gpm",         default: 0
    t.integer  "sum_xpm",         default: 0
    t.integer  "sum_kills",       default: 0
    t.integer  "sum_assists",     default: 0
    t.integer  "sum_deaths",      default: 0
    t.integer  "sum_lasthits",    default: 0
    t.integer  "sum_denies",      default: 0
    t.integer  "sum_herodamage",  default: 0
    t.integer  "sum_towerdamage", default: 0
    t.integer  "sum_level",       default: 0
    t.float    "sum_tfc",         default: 0.0
  end

  add_index "players", ["accountid"], name: "index_players_on_accountid", unique: true

  create_table "time_series", force: true do |t|
    t.integer "minute"
    t.integer "xp"
    t.integer "gold"
    t.integer "lasthits"
    t.integer "denies"
    t.integer "match_participation_id"
  end

  add_index "time_series", ["match_participation_id", "minute"], name: "index_time_series_on_match_participation_id_and_minute"

end
