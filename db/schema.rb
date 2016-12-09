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

ActiveRecord::Schema.define(version: 20161209043834) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status_id"
    t.text     "title"
    t.text     "subtitle"
    t.text     "content"
    t.text     "css"
    t.text     "image"
    t.text     "image_description"
    t.string   "slug"
    t.string   "draft_code"
    t.datetime "published_at"
    t.string   "year"
    t.string   "month"
    t.string   "day"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["status_id"], name: "index_articles_on_status_id", using: :btree
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorizations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "article_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "name"
    t.text     "url"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_links_on_user_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status_id"
    t.text     "title"
    t.text     "subtitle"
    t.text     "content"
    t.text     "css"
    t.text     "image"
    t.text     "image_description"
    t.string   "slug"
    t.string   "draft_code"
    t.datetime "published_at"
    t.boolean  "hide_header",       default: false
    t.boolean  "hide_footer",       default: false
    t.boolean  "hide_layout",       default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["status_id"], name: "index_pages_on_status_id", using: :btree
    t.index ["user_id"], name: "index_pages_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "saved_content"
    t.boolean  "editable",      default: true
    t.string   "form_element",  default: "text_field"
    t.text     "fallback"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "display_name"
    t.string   "password"
    t.string   "password_digest"
    t.text     "avatar"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "links", "users"
end
