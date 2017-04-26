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

ActiveRecord::Schema.define(version: 20170426222652) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bracket_points", force: :cascade do |t|
    t.integer "bracket_id", null: false
    t.integer "points", default: 0, null: false
    t.integer "possible_points", default: 0, null: false
    t.integer "best_possible", default: 60000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["best_possible"], name: "index_bracket_points_on_best_possible"
    t.index ["bracket_id"], name: "index_bracket_points_on_bracket_id", unique: true
    t.index ["points"], name: "index_bracket_points_on_points"
    t.index ["possible_points"], name: "index_bracket_points_on_possible_points"
  end

  create_table "brackets", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "charge_id"
    t.integer "tie_breaker"
    t.integer "payment_collector_id"
    t.string "stripe_charge_id"
    t.string "name", null: false
    t.integer "payment_state", default: 0
    t.integer "pool_id", null: false
    t.decimal "tree_decisions", precision: 20, default: "0", null: false
    t.decimal "tree_mask", precision: 20, default: "0", null: false
    t.index ["charge_id"], name: "index_brackets_on_stripe_charge_id"
    t.index ["name"], name: "index_brackets_on_name"
    t.index ["payment_collector_id"], name: "index_brackets_on_payment_collector_id"
    t.index ["pool_id", "name"], name: "index_brackets_on_pool_id_and_name", unique: true
    t.index ["pool_id"], name: "index_brackets_on_pool_id"
    t.index ["user_id"], name: "index_brackets_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.string "order_id"
    t.datetime "completed_at"
    t.integer "amount"
    t.text "transaction_hash"
    t.integer "bracket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bracket_id"], name: "index_charges_on_bracket_id", unique: true
  end

  create_table "pool_users", force: :cascade do |t|
    t.integer "pool_id", null: false
    t.integer "user_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pool_id", "user_id"], name: "index_pool_users_on_pool_id_and_user_id", unique: true
    t.index ["pool_id"], name: "index_pool_users_on_pool_id"
    t.index ["role"], name: "index_pool_users_on_role"
    t.index ["user_id"], name: "index_pool_users_on_user_id"
  end

  create_table "pools", force: :cascade do |t|
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "invite_code"
    t.integer "entry_fee", default: 1000, null: false
    t.index ["invite_code"], name: "index_pools_on_invite_code", unique: true
    t.index ["tournament_id", "name"], name: "index_pools_on_tournament_id_and_name", unique: true
    t.index ["tournament_id"], name: "index_pools_on_tournament_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.integer "seed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "score_team_id"
    t.string "region"
    t.integer "tournament_id", null: false
    t.integer "starting_slot"
    t.index ["region"], name: "index_teams_on_region"
    t.index ["score_team_id"], name: "index_teams_on_score_team_id"
    t.index ["seed"], name: "index_teams_on_seed"
    t.index ["starting_slot"], name: "index_teams_on_starting_slot"
    t.index ["tournament_id", "name"], name: "index_teams_on_tournament_id_and_name", unique: true
    t.index ["tournament_id", "region", "seed"], name: "index_teams_on_tournament_id_and_region_and_seed", unique: true
    t.index ["tournament_id", "starting_slot"], name: "index_teams_on_tournament_id_and_starting_slot", unique: true
    t.index ["tournament_id"], name: "index_teams_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.datetime "tip_off"
    t.integer "eliminating_offset", default: 345600, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "num_rounds", default: 6, null: false
    t.decimal "game_decisions", precision: 20, default: "0", null: false
    t.decimal "game_mask", precision: 20, default: "0", null: false
    t.index ["name"], name: "index_tournaments_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "stripe_customer_id"
    t.integer "role", default: 0
    t.string "auth0_id"
    t.index ["auth0_id"], name: "index_users_on_auth0_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
