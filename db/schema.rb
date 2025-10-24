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

ActiveRecord::Schema[8.1].define(version: 2025_07_31_001410) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.integer "canonical_id"
    t.integer "collection_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.datetime "created_at", null: false
    t.text "css"
    t.string "day"
    t.string "draft_code"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "hide_from_index", default: false
    t.text "image"
    t.text "image_description"
    t.text "image_mobile"
    t.string "locale", default: "en"
    t.string "month"
    t.text "notes"
    t.integer "page_views", default: 0
    t.integer "position"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.string "short_path"
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", null: false
    t.text "word_doc"
    t.string "year"
    t.index ["canonical_id"], name: "index_articles_on_canonical_id"
    t.index ["collection_id"], name: "index_articles_on_collection_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.boolean "back_image_present", default: false
    t.text "binding_style"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.text "cover_style"
    t.datetime "created_at", null: false
    t.string "definitions"
    t.string "depth"
    t.text "description"
    t.boolean "epub_download_present"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "front_image_present", default: false
    t.integer "gallery_images_count"
    t.boolean "has_index"
    t.string "height"
    t.boolean "hide_from_index", default: false
    t.string "illustrations"
    t.string "ink"
    t.boolean "lite_download_present", default: false
    t.string "locale", default: "en"
    t.boolean "mobi_download_present"
    t.string "pages"
    t.string "photographs"
    t.integer "position"
    t.integer "price_in_cents"
    t.boolean "print_black_and_white_a4_download_present"
    t.boolean "print_black_and_white_download_present"
    t.boolean "print_color_a4_download_present"
    t.boolean "print_color_download_present"
    t.string "printing"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "recipes"
    t.boolean "screen_single_page_view_download_present"
    t.boolean "screen_two_page_view_download_present"
    t.string "series"
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "table_of_contents"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", null: false
    t.string "weight"
    t.string "width"
    t.string "words"
    t.index ["canonical_id"], name: "index_books_on_canonical_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categorizations", id: :serial, force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "definitions", force: :cascade do |t|
    t.integer "canonical_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "draft_code"
    t.datetime "featured_at"
    t.boolean "featured_status", default: false
    t.string "filed_under"
    t.string "locale", default: "en"
    t.string "publication_status"
    t.datetime "published_at"
    t.string "slug"
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_definitions_on_canonical_id"
  end

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.string "audio_length"
    t.string "audio_mp3_file_size"
    t.text "audio_mp3_url"
    t.string "audio_ogg_file_size"
    t.text "audio_ogg_url"
    t.string "audio_type", default: "audio/mpeg"
    t.integer "canonical_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.string "draft_code"
    t.string "duration"
    t.string "episode_number"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false, null: false
    t.text "image"
    t.string "locale", default: "en"
    t.integer "podcast_id", default: 1
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.text "show_notes"
    t.string "slug"
    t.string "subtitle"
    t.string "tags"
    t.string "title"
    t.text "transcript"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_episodes_on_canonical_id"
    t.index ["podcast_id"], name: "index_episodes_on_podcast_id"
  end

  create_table "issues", force: :cascade do |t|
    t.boolean "back_image_present", default: false
    t.text "binding_style"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.text "cover_style"
    t.datetime "created_at", precision: nil
    t.string "definitions"
    t.string "depth"
    t.text "description"
    t.boolean "epub_download_present"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "front_image_present", default: false
    t.integer "gallery_images_count"
    t.boolean "has_index"
    t.string "height"
    t.boolean "hide_from_index", default: false
    t.string "illustrations"
    t.string "ink"
    t.integer "issue"
    t.integer "journal_id"
    t.boolean "lite_download_present", default: false
    t.string "locale", default: "en"
    t.boolean "mobi_download_present"
    t.string "pages"
    t.string "photographs"
    t.integer "position"
    t.integer "price_in_cents"
    t.boolean "print_black_and_white_a4_download_present"
    t.boolean "print_black_and_white_download_present"
    t.boolean "print_color_a4_download_present"
    t.boolean "print_color_download_present"
    t.string "printing"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "recipes"
    t.boolean "screen_single_page_view_download_present"
    t.boolean "screen_two_page_view_download_present"
    t.string "series"
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "table_of_contents"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", precision: nil
    t.string "weight"
    t.string "width"
    t.string "words"
    t.index ["canonical_id"], name: "index_issues_on_canonical_id"
  end

  create_table "journals", force: :cascade do |t|
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false, null: false
    t.boolean "hide_from_index", default: false
    t.string "locale", default: "en"
    t.integer "position"
    t.integer "price_in_cents"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "slug"
    t.string "subtitle"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_journals_on_canonical_id"
  end

  create_table "locales", force: :cascade do |t|
    t.string "abbreviation"
    t.integer "articles_count", default: 0
    t.datetime "created_at", null: false
    t.string "language_direction"
    t.string "name"
    t.string "name_in_english"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_locales_on_abbreviation", unique: true
    t.index ["name"], name: "index_locales_on_name", unique: true
    t.index ["name_in_english"], name: "index_locales_on_name_in_english", unique: true
  end

  create_table "logos", force: :cascade do |t|
    t.integer "canonical_id"
    t.string "content_format"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false, null: false
    t.boolean "hide_from_index", default: false
    t.string "locale", default: "en"
    t.integer "position"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "slug"
    t.string "subtitle"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_logos_on_canonical_id"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.datetime "created_at", null: false
    t.text "css"
    t.string "draft_code"
    t.string "header_background_color"
    t.string "header_text_color"
    t.text "image"
    t.text "image_description"
    t.string "locale", default: "en"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_pages_on_canonical_id"
  end

  create_table "podcasts", id: :serial, force: :cascade do |t|
    t.integer "canonical_id"
    t.text "content"
    t.string "copyright"
    t.datetime "created_at", null: false
    t.string "episode_prefix"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false, null: false
    t.text "image"
    t.string "itunes_author"
    t.string "itunes_categories"
    t.boolean "itunes_explicit", default: true
    t.string "itunes_owner_email"
    t.string "itunes_owner_name"
    t.string "itunes_summary"
    t.text "itunes_url"
    t.string "language"
    t.string "locale", default: "en"
    t.text "overcast_url"
    t.text "pocketcasts_url"
    t.string "slug"
    t.string "subtitle"
    t.string "tags"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_podcasts_on_canonical_id"
    t.index ["slug"], name: "index_podcasts_on_slug", unique: true
  end

  create_table "posters", force: :cascade do |t|
    t.boolean "back_black_and_white_download_present"
    t.boolean "back_black_and_white_image_present"
    t.boolean "back_color_download_present"
    t.boolean "back_color_image_present"
    t.string "back_image_format", default: "jpg"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.datetime "created_at", null: false
    t.string "depth"
    t.text "description"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "front_black_and_white_download_present"
    t.boolean "front_black_and_white_image_present"
    t.boolean "front_color_download_present"
    t.boolean "front_color_image_present"
    t.string "front_image_format", default: "jpg"
    t.string "height"
    t.boolean "hide_from_index", default: false
    t.string "locale", default: "en"
    t.integer "position"
    t.integer "price_in_cents"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.text "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "title"
    t.datetime "updated_at", null: false
    t.string "width"
    t.index ["canonical_id"], name: "index_posters_on_canonical_id"
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.string "source_path"
    t.string "target_path"
    t.boolean "temporary"
    t.datetime "updated_at", null: false
    t.index ["source_path"], name: "index_redirects_on_source_path", unique: true
  end

  create_table "stickers", force: :cascade do |t|
    t.boolean "back_black_and_white_download_present"
    t.boolean "back_black_and_white_image_present"
    t.boolean "back_color_download_present"
    t.boolean "back_color_image_present"
    t.string "back_image_format", default: "jpg"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.datetime "created_at", null: false
    t.string "depth"
    t.text "description"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "front_black_and_white_download_present"
    t.boolean "front_black_and_white_image_present"
    t.boolean "front_color_download_present"
    t.boolean "front_color_image_present"
    t.string "front_image_format", default: "jpg"
    t.string "height"
    t.boolean "hide_from_index", default: false
    t.string "locale", default: "en"
    t.integer "position"
    t.integer "price_in_cents"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.text "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "title"
    t.datetime "updated_at", null: false
    t.string "width"
    t.index ["canonical_id"], name: "index_stickers_on_canonical_id"
  end

  create_table "support_sessions", force: :cascade do |t|
    t.datetime "expires_at", precision: nil
    t.string "stripe_customer_id"
    t.string "token"
    t.index ["stripe_customer_id"], name: "index_support_sessions_on_stripe_customer_id", unique: true
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "canonical_id"
    t.datetime "created_at", null: false
    t.string "locale", default: "en"
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["canonical_id"], name: "index_tags_on_canonical_id"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.datetime "created_at", null: false
    t.string "day"
    t.string "duration"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false, null: false
    t.text "image_description"
    t.string "locale", default: "en"
    t.string "month"
    t.text "peer_tube_url"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.string "quality"
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", null: false
    t.string "vimeo_id"
    t.string "year"
    t.index ["canonical_id"], name: "index_videos_on_canonical_id"
  end

  create_table "zines", force: :cascade do |t|
    t.boolean "back_image_present", default: false
    t.text "binding_style"
    t.text "buy_info"
    t.text "buy_url"
    t.integer "canonical_id"
    t.text "content"
    t.string "content_format", default: "kramdown"
    t.text "cover_style"
    t.datetime "created_at", null: false
    t.string "definitions"
    t.string "depth"
    t.text "description"
    t.boolean "epub_download_present"
    t.datetime "featured_at", precision: nil
    t.boolean "featured_status", default: false
    t.boolean "front_image_present", default: false
    t.integer "gallery_images_count"
    t.boolean "has_index"
    t.string "height"
    t.boolean "hide_from_index", default: false
    t.string "illustrations"
    t.string "ink"
    t.boolean "lite_download_present", default: false
    t.string "locale", default: "en"
    t.boolean "mobi_download_present"
    t.string "pages"
    t.string "photographs"
    t.integer "position"
    t.integer "price_in_cents"
    t.boolean "print_black_and_white_a4_download_present"
    t.boolean "print_black_and_white_download_present"
    t.boolean "print_color_a4_download_present"
    t.boolean "print_color_download_present"
    t.string "printing"
    t.string "publication_status"
    t.datetime "published_at", precision: nil
    t.string "recipes"
    t.boolean "screen_single_page_view_download_present"
    t.boolean "screen_two_page_view_download_present"
    t.string "series"
    t.string "slug"
    t.text "subtitle"
    t.text "summary"
    t.text "table_of_contents"
    t.text "title"
    t.text "tweet"
    t.datetime "updated_at", null: false
    t.string "weight"
    t.string "width"
    t.string "words"
    t.index ["canonical_id"], name: "index_zines_on_canonical_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
