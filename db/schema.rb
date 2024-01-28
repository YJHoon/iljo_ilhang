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

ActiveRecord::Schema[7.1].define(version: 2024_01_10_135044) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_members", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "bill_id"
    t.string "name"
    t.integer "proposer_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_members_on_bill_id"
    t.index ["member_id"], name: "index_bill_members_on_member_id"
  end

  create_table "bills", force: :cascade do |t|
    t.string "bill_id"
    t.string "bill_no"
    t.string "bill_name"
    t.string "proc_result"
    t.date "propose_date"
    t.string "age"
    t.jsonb "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.jsonb "reponse"
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
    t.jsonb "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.bigint "political_party_id"
    t.integer "seq_id"
    t.string "name"
    t.string "image"
    t.float "attendance"
    t.date "birth"
    t.integer "gender", default: 0
    t.integer "status", default: 0
    t.jsonb "response"
    t.jsonb "show_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "is_active", default: false
    t.float "average_attendance", default: 0.0
    t.integer "members_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "response_logs", force: :cascade do |t|
    t.string "msg"
    t.integer "request_type", default: 0
    t.jsonb "response"
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
    t.jsonb "response"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bill_members", "bills"
  add_foreign_key "bill_members", "members"
  add_foreign_key "candidates", "elections"
  add_foreign_key "candidates", "political_parties"
  add_foreign_key "members", "political_parties"
  add_foreign_key "pledges", "members"
end
