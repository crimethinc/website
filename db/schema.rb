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

ActiveRecord::Schema.define(version: 20170620025614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "status_id"
    t.integer "theme_id"
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.text "tweet"
    t.text "summary"
    t.text "image"
    t.text "image_description"
    t.text "css"
    t.text "download_url"
    t.string "header_background_color"
    t.string "header_text_color"
    t.string "content_format", default: "kramdown"
    t.string "slug"
    t.string "draft_code"
    t.datetime "published_at"
    t.string "year"
    t.string "month"
    t.string "day"
    t.boolean "hide_layout", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "collection_id"
    t.string "short_path"
    t.boolean "header_shadow_text"
    t.index ["collection_id"], name: "index_articles_on_collection_id"
    t.index ["status_id"], name: "index_articles_on_status_id"
    t.index ["theme_id"], name: "index_articles_on_theme_id"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.text "tweet"
    t.text "summary"
    t.text "description"
    t.text "buy_url"
    t.text "buy_info"
    t.string "content_format", default: "kramdown"
    t.string "slug"
    t.string "series"
    t.datetime "published_at"
    t.integer "price_in_cents"
    t.string "height"
    t.string "width"
    t.string "depth"
    t.string "weight"
    t.string "pages"
    t.string "words"
    t.string "illustrations"
    t.string "photographs"
    t.string "printing"
    t.string "ink"
    t.string "definitions"
    t.string "recipes"
    t.boolean "has_index"
    t.text "cover_style"
    t.text "binding_style"
    t.text "table_of_contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "zine", default: false
    t.boolean "back_image_present", default: false
    t.boolean "front_image_present", default: false
    t.boolean "read_download_present", default: false
    t.boolean "print_download_present", default: false
    t.boolean "lite_download_present", default: false
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorizations", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contributions", id: :serial, force: :cascade do |t|
    t.integer "article_id"
    t.integer "contributor_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_contributions_on_article_id"
    t.index ["contributor_id"], name: "index_contributions_on_contributor_id"
    t.index ["role_id"], name: "index_contributions_on_role_id"
  end

  create_table "contributors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.text "bio"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_contributors_on_slug", unique: true
  end

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.integer "podcast_id"
    t.string "title"
    t.string "subtitle"
    t.text "image"
    t.string "content"
    t.text "audio_mp3_url"
    t.string "audio_mp3_file_size"
    t.text "audio_ogg_url"
    t.string "audio_ogg_file_size"
    t.text "show_notes"
    t.text "transcript"
    t.string "audio_length"
    t.string "duration"
    t.string "audio_type", default: "audio/mpeg"
    t.string "tags"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
  end

  create_table "links", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "status_id"
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.text "tweet"
    t.text "summary"
    t.text "image"
    t.text "image_description"
    t.text "css"
    t.string "header_background_color"
    t.string "header_text_color"
    t.string "content_format", default: "kramdown"
    t.string "slug"
    t.string "draft_code"
    t.datetime "published_at"
    t.boolean "hide_header", default: false
    t.boolean "hide_footer", default: false
    t.boolean "hide_layout", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status_id"], name: "index_pages_on_status_id"
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "podcasts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.string "slug"
    t.string "language"
    t.string "copyright"
    t.text "image"
    t.text "content"
    t.string "itunes_author"
    t.string "itunes_categories"
    t.boolean "itunes_explicit", default: true
    t.string "tags"
    t.string "itunes_summary"
    t.string "itunes_owner_name"
    t.string "itunes_owner_email"
    t.text "itunes_url"
    t.text "overcast_url"
    t.text "pocketcasts_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posters", force: :cascade do |t|
    t.boolean "sticker"
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "price_in_cents"
    t.text "summary"
    t.text "description"
    t.boolean "front_image_present", default: true
    t.boolean "back_image_present", default: false
    t.boolean "front_download_present", default: false
    t.boolean "back_download_present", default: false
    t.text "slug"
    t.string "height"
    t.string "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.string "source_path"
    t.string "target_path"
    t.boolean "temporary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "saved_content"
    t.boolean "editable", default: true
    t.string "form_element", default: "text_field"
    t.text "fallback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "frequency", default: "weekly"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "taggable_type"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "themes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "display_name"
    t.string "password_digest"
    t.text "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.text "tweet"
    t.text "summary"
    t.text "image"
    t.text "image_description"
    t.string "content_format", default: "kramdown"
    t.string "slug"
    t.string "quality"
    t.string "duration"
    t.string "vimeo_id"
    t.datetime "published_at"
    t.string "year"
    t.string "month"
    t.string "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contributions", "articles"
  add_foreign_key "contributions", "contributors"
  add_foreign_key "contributions", "roles"
  add_foreign_key "links", "users"
end
