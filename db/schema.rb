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

ActiveRecord::Schema[7.1].define(version: 2023_11_30_073038) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "elections", force: :cascade do |t|
    t.string "title"
    t.string "date"
    t.string "sg_id"
    t.boolean "is_active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.bigint "political_party_id"
    t.bigint "election_id"
    t.string "name"
    t.string "region"
    t.string "birth"
    t.string "edu"
    t.string "job"
    t.string "career1"
    t.string "career2"
    t.string "hubo_id"
    t.integer "gender", default: 0
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_members_on_election_id"
    t.index ["political_party_id"], name: "index_members_on_political_party_id"
  end

  create_table "pledges", force: :cascade do |t|
    t.bigint "member_id", null: false
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

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "birth"
    t.string "phone"
    t.integer "gender", default: 0
    t.string "uid"
    t.json "response"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "members", "elections"
  add_foreign_key "members", "political_parties"
  add_foreign_key "pledges", "members"
end
