# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_14_081201) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.bigint "political_party_id"
    t.bigint "election_id"
    t.string "name"
    t.string "image"
    t.string "region"
    t.date "birth"
    t.integer "gender", default: 0
    t.integer "status", default: 0
    t.string "hubo_id"
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_candidates_on_election_id"
    t.index ["political_party_id"], name: "index_candidates_on_political_party_id"
  end

  create_table "elections", force: :cascade do |t|
    t.string "title"
    t.string "vote_date"
    t.string "sg_id"
    t.string "sg_type_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "error_logs", force: :cascade do |t|
    t.string "msg"
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.bigint "political_party_id"
    t.bigint "election_id"
    t.string "name"
    t.string "image"
    t.date "birth"
    t.integer "gender", default: 0
    t.integer "status", default: 0
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_members_on_election_id"
    t.index ["political_party_id"], name: "index_members_on_political_party_id"
  end

  create_table "pledges", force: :cascade do |t|
    t.bigint "member_id"
    t.string "title"
    t.string "goal"
    t.string "method"
    t.string "period"
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_pledges_on_member_id"
  end

  create_table "political_parties", force: :cascade do |t|
    t.string "name"
    t.string "banner_image"
    t.string "logo_image"
    t.boolean "is_active", default: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "response_logs", force: :cascade do |t|
    t.string "msg"
    t.integer "request_type", default: 0
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "birth"
    t.string "phone"
    t.integer "gender", default: 0
    t.string "uid"
    t.json "response"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "candidates", "elections"
  add_foreign_key "candidates", "political_parties"
  add_foreign_key "members", "elections"
  add_foreign_key "members", "political_parties"
  add_foreign_key "pledges", "members"
end
