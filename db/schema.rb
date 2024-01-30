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

ActiveRecord::Schema[7.0].define(version: 2024_01_29_165058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "benefits", force: :cascade do |t|
    t.string "text"
    t.integer "category"
    t.bigint "guideline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guideline_id"], name: "index_benefits_on_guideline_id"
  end

  create_table "criteria", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.bigint "guideline_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guideline_id"], name: "index_criteria_on_guideline_id"
  end

  create_table "guidelines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.integer "effort"
    t.integer "impact"
    t.integer "category"
    t.string "link_url"
  end

  create_table "site_checks", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_images", force: :cascade do |t|
    t.bigint "site_check_id", null: false
    t.string "url"
    t.integer "size"
    t.integer "size_kb"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_check_id"], name: "index_site_images_on_site_check_id"
  end

  add_foreign_key "benefits", "guidelines"
  add_foreign_key "criteria", "guidelines"
  add_foreign_key "site_images", "site_checks"
end
