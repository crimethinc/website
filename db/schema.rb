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

ActiveRecord::Schema.define(version: 20170104053747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status_id"
    t.integer  "theme_id"
    t.text     "title"
    t.text     "subtitle"
    t.text     "content"
    t.text     "tweet"
    t.text     "summary"
    t.text     "image"
    t.text     "image_description"
    t.text     "css"
    t.text     "download_url"
    t.string   "header_background_color"
    t.string   "header_text_color"
    t.string   "content_format",          default: "kramdown"
    t.string   "slug"
    t.string   "draft_code"
    t.datetime "published_at"
    t.string   "year"
    t.string   "month"
    t.string   "day"
    t.boolean  "hide_layout",             default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["status_id"], name: "index_articles_on_status_id", using: :btree
    t.index ["theme_id"], name: "index_articles_on_theme_id", using: :btree
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.text     "title"
    t.text     "subtitle"
    t.text     "content"
    t.text     "tweet"
    t.text     "summary"
    t.text     "download_url"
    t.text     "buy_url"
    t.text     "description"
    t.string   "content_format",    default: "kramdown"
    t.string   "slug"
    t.string   "series"
    t.datetime "published_at"
    t.integer  "price_in_cents"
    t.string   "height"
    t.string   "width"
    t.string   "depth"
    t.string   "weight"
    t.string   "pages"
    t.string   "words"
    t.string   "illustrations"
    t.string   "photographs"
    t.string   "printing"
    t.string   "ink"
    t.string   "definitions"
    t.string   "recipes"
    t.boolean  "has_index"
    t.text     "cover_style"
    t.text     "binding_style"
    t.text     "table_of_contents"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
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

  create_table "episodes", force: :cascade do |t|
    t.integer  "podcast_id"
    t.string   "title"
    t.string   "subtitle"
    t.text     "image"
    t.string   "content"
    t.text     "audio_mp3_url"
    t.string   "audio_mp3_file_size"
    t.text     "audio_ogg_url"
    t.string   "audio_ogg_file_size"
    t.text     "show_notes"
    t.text     "transcript"
    t.string   "audio_length"
    t.string   "duration"
    t.string   "audio_type",          default: "audio/mpeg"
    t.string   "tags"
    t.datetime "published_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id", using: :btree
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
    t.text     "tweet"
    t.text     "summary"
    t.text     "image"
    t.text     "image_description"
    t.text     "css"
    t.string   "header_background_color"
    t.string   "header_text_color"
    t.string   "content_format",          default: "kramdown"
    t.string   "slug"
    t.string   "draft_code"
    t.datetime "published_at"
    t.boolean  "hide_header",             default: false
    t.boolean  "hide_footer",             default: false
    t.boolean  "hide_layout",             default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["status_id"], name: "index_pages_on_status_id", using: :btree
    t.index ["user_id"], name: "index_pages_on_user_id", using: :btree
  end

  create_table "podcasts", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "slug"
    t.string   "language"
    t.string   "copyright"
    t.text     "image"
    t.text     "content"
    t.string   "itunes_author"
    t.string   "itunes_categories"
    t.boolean  "itunes_explicit",    default: true
    t.string   "tags"
    t.string   "itunes_summary"
    t.string   "itunes_owner_name"
    t.string   "itunes_owner_email"
    t.text     "itunes_url"
    t.text     "overcast_url"
    t.text     "pocketcasts_url"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "redirects", force: :cascade do |t|
    t.string   "source_path"
    t.string   "target_path"
    t.boolean  "temporary"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.string   "frequency",  default: "weekly"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
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

  create_table "themes", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "display_name"
    t.string   "password_digest"
    t.text     "avatar"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "videos", force: :cascade do |t|
    t.text     "title"
    t.text     "subtitle"
    t.text     "content"
    t.text     "tweet"
    t.text     "summary"
    t.text     "image"
    t.text     "image_description"
    t.string   "content_format",    default: "kramdown"
    t.string   "slug"
    t.string   "quality"
    t.string   "duration"
    t.string   "vimeo_id"
    t.datetime "published_at"
    t.string   "year"
    t.string   "month"
    t.string   "day"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_foreign_key "links", "users"
end
