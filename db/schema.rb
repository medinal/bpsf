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

ActiveRecord::Schema.define(version: 20170512231338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grants", force: :cascade do |t|
    t.text     "title"
    t.text     "summary"
    t.text     "grade_level"
    t.text     "duration"
    t.integer  "num_classes"
    t.integer  "num_students"
    t.integer  "total_budget"
    t.text     "budget_desc"
    t.text     "purpose"
    t.text     "methods"
    t.text     "background"
    t.integer  "num_collabs"
    t.text     "collaborators"
    t.text     "comments"
    t.integer  "user_id"
    t.string   "state"
    t.string   "video"
    t.string   "image"
    t.integer  "school_id"
    t.integer  "status"
    t.date     "deadline"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "subject_areas"
    t.integer  "funds_will_pay_for"
    t.index ["school_id"], name: "index_grants_on_school_id", using: :btree
    t.index ["user_id"], name: "index_grants_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.integer  "grant_id"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grant_id"], name: "index_payments_on_grant_id", using: :btree
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.text     "about"
    t.string   "address"
    t.string   "city"
    t.string   "position"
    t.text     "state"
    t.text     "zipcode"
    t.string   "grade"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "subject"
    t.text     "relationship"
    t.datetime "started_teaching"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.integer  "donations_received"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stripe_token"
    t.boolean  "teacher"
    t.boolean  "approved"
    t.integer  "school_id"
    t.integer  "role"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["school_id"], name: "index_users_on_school_id", using: :btree
  end

  add_foreign_key "grants", "schools"
  add_foreign_key "grants", "users"
  add_foreign_key "payments", "grants"
  add_foreign_key "payments", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "users", "schools"
end
