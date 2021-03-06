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

ActiveRecord::Schema.define(version: 20160111102545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "step"
    t.decimal  "start_hour"
    t.boolean  "archived"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "end_hour"
    t.string   "name_cabinet"
  end

  create_table "cabinet_details", force: :cascade do |t|
    t.string   "name"
    t.text     "street"
    t.string   "zipcode"
    t.string   "town"
    t.string   "specialty"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "tel"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "number"
    t.string   "email"
    t.string   "tel"
    t.boolean  "cgv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "patient_id"
    t.integer  "agenda_id"
    t.string   "status"
    t.string   "recurring_status"
    t.boolean  "is_recurring"
    t.text     "comments"
    t.integer  "created_by"
  end

  create_table "organisations", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "organisation_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "patients", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "gender"
    t.string   "name"
    t.string   "firstname"
    t.string   "email"
    t.string   "tel"
    t.text     "street"
    t.string   "zipcode"
    t.string   "town"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "birthday"
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "status"
    t.text     "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "firstname"
    t.string   "email"
    t.string   "role"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
