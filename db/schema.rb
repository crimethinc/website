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

ActiveRecord::Schema.define(version: 20171213083856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "articles", id: :serial, force: :cascade do |t|
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
    t.boolean "header_shadow_text", default: true
    t.text "image_mobile"
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.integer "page_views", default: 0
    t.index ["collection_id"], name: "index_articles_on_collection_id"
    t.index ["status_id"], name: "index_articles_on_status_id"
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
    t.boolean "lite_download_present", default: false
    t.integer "gallery_images_count"
    t.boolean "epub_download_present"
    t.boolean "mobi_download_present"
    t.integer "status_id"
    t.boolean "print_black_and_white_a4_download_present"
    t.boolean "print_color_a4_download_present"
    t.boolean "print_color_download_present"
    t.boolean "print_black_and_white_download_present"
    t.boolean "screen_single_page_view_download_present"
    t.boolean "screen_two_page_view_download_present"
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

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.integer "podcast_id", default: 1
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
    t.string "slug"
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
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

  create_table "logos", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.string "height"
    t.string "width"
    t.string "content_format"
    t.boolean "jpg_url_present"
    t.boolean "png_url_present"
    t.boolean "pdf_url_present"
    t.boolean "svg_url_present"
    t.boolean "tif_url_present"
    t.datetime "published_at"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id"
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
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
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
    t.string "episode_prefix"
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
    t.text "slug"
    t.string "height"
    t.string "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "depth"
    t.string "front_image_format", default: "jpg"
    t.string "back_image_format", default: "jpg"
    t.datetime "published_at"
    t.boolean "front_color_image_present"
    t.boolean "front_black_and_white_image_present"
    t.boolean "back_color_image_present"
    t.boolean "back_black_and_white_image_present"
    t.boolean "front_color_download_present"
    t.boolean "front_black_and_white_download_present"
    t.boolean "back_color_download_present"
    t.boolean "back_black_and_white_download_present"
    t.integer "status_id"
  end

  create_table "redirects", id: :serial, force: :cascade do |t|
    t.string "source_path"
    t.string "target_path"
    t.boolean "temporary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_id"
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

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
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
    t.string "published_at_tz", default: "Pacific Time (US & Canada)", null: false
    t.integer "status_id"
  end

  add_foreign_key "links", "users"

  create_view "search_results", materialized: true,  sql_definition: <<-SQL
      SELECT a.searchable_id,
      a.searchable_type,
      a.title,
      a.subtitle,
      a.content,
      a.tag_names AS tag,
      a.category_names AS category,
      ((((setweight(a.title, 'A'::"char") || setweight(a.subtitle, 'B'::"char")) || setweight(a.content, 'C'::"char")) || setweight(array_to_tsvector((a.tag_names)::text[]), 'D'::"char")) || setweight(array_to_tsvector((a.category_names)::text[]), 'D'::"char")) AS document
     FROM ( SELECT articles.id AS searchable_id,
              'Article'::text AS searchable_type,
              to_tsvector(COALESCE(articles.title, ''::text)) AS title,
              to_tsvector(COALESCE(articles.subtitle, ''::text)) AS subtitle,
              to_tsvector(COALESCE(articles.content, ''::text)) AS content,
                  CASE
                      WHEN (count(tags.*) = 0) THEN (ARRAY[]::text[])::character varying[]
                      ELSE array_agg(tags.name)
                  END AS tag_names,
                  CASE
                      WHEN (count(categories.*) = 0) THEN (ARRAY[]::text[])::character varying[]
                      ELSE array_agg(categories.name)
                  END AS category_names
             FROM (((((articles
               JOIN statuses ON (((statuses.id = articles.status_id) AND ((statuses.name)::text = 'published'::text))))
               LEFT JOIN taggings ON (((taggings.taggable_id = articles.id) AND ((taggings.taggable_type)::text = 'Article'::text))))
               LEFT JOIN tags ON ((tags.id = taggings.tag_id)))
               LEFT JOIN categorizations ON ((categorizations.article_id = articles.id)))
               LEFT JOIN categories ON ((categories.id = categorizations.category_id)))
            WHERE (articles.published_at < now())
            GROUP BY articles.id, 'Article'::text
          UNION
           SELECT pages.id AS searchable_id,
              'Page'::text AS searchable_type,
              to_tsvector(COALESCE(pages.title, ''::text)) AS title,
              to_tsvector(COALESCE(pages.subtitle, ''::text)) AS subtitle,
              to_tsvector(COALESCE(pages.content, ''::text)) AS content,
                  CASE
                      WHEN (count(tags.*) = 0) THEN (ARRAY[]::text[])::character varying[]
                      ELSE array_agg(tags.name)
                  END AS tag_names,
              ARRAY[]::text[] AS category_names
             FROM (((pages
               JOIN statuses ON (((statuses.id = pages.status_id) AND ((statuses.name)::text = 'published'::text))))
               LEFT JOIN taggings ON (((taggings.taggable_id = pages.id) AND ((taggings.taggable_type)::text = 'Page'::text))))
               LEFT JOIN tags ON ((tags.id = taggings.tag_id)))
            WHERE (pages.published_at < now())
            GROUP BY pages.id, 'Page'::text
          UNION
           SELECT episodes.id AS searchable_id,
              'Episode'::text AS searchable_type,
              to_tsvector((COALESCE(episodes.title, ''::character varying))::text) AS title,
              to_tsvector((COALESCE(episodes.subtitle, ''::character varying))::text) AS subtitle,
              to_tsvector((COALESCE(episodes.content, ''::character varying))::text) AS content,
              ARRAY[]::text[] AS tag_names,
              ARRAY[]::text[] AS category_names
             FROM episodes
            GROUP BY episodes.id, 'Episode'::text) a;
  SQL

  add_index "search_results", ["category"], name: "index_search_results_on_category", using: :gin
  add_index "search_results", ["content"], name: "index_search_results_on_content", using: :gist
  add_index "search_results", ["document"], name: "index_search_results_on_document", using: :gist
  add_index "search_results", ["searchable_id", "searchable_type"], name: "index_search_results_on_searchable_id_and_searchable_type", unique: true
  add_index "search_results", ["subtitle"], name: "index_search_results_on_subtitle", using: :gist
  add_index "search_results", ["tag"], name: "index_search_results_on_tag", using: :gin
  add_index "search_results", ["title"], name: "index_search_results_on_title", using: :gist

end
