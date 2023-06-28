class InitSchema < ActiveRecord::Migration
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension 'plpgsql'

    create_table 'active_storage_attachments' do |t|
      t.string 'name', null: false
      t.string 'record_type', null: false
      t.bigint 'record_id', null: false
      t.bigint 'blob_id', null: false
      t.datetime 'created_at', precision: nil, null: false

      t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
      t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
    end

    create_table 'active_storage_blobs' do |t|
      t.string 'key', null: false
      t.string 'filename', null: false
      t.string 'content_type'
      t.text 'metadata'
      t.bigint 'byte_size', null: false
      t.string 'checksum'
      t.datetime 'created_at', precision: nil, null: false
      t.string 'service_name', null: false

      t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
    end

    create_table 'active_storage_variant_records' do |t|
      t.bigint 'blob_id', null: false
      t.string 'variation_digest', null: false

      t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
    end

    create_table 'articles', id: :serial do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'image'
      t.text 'image_description'
      t.text 'css'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'draft_code'
      t.datetime 'published_at', precision: nil
      t.string 'year'
      t.string 'month'
      t.string 'day'
      t.integer 'collection_id'
      t.string 'short_path'
      t.text 'image_mobile'
      t.string 'published_at_tz', default: 'Pacific Time (US & Canada)', null: false
      t.integer 'page_views', default: 0
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.text 'word_doc'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false
      t.text 'notes'

      t.timestamps

      t.index ['canonical_id'], name: 'index_articles_on_canonical_id'
      t.index ['collection_id'], name: 'index_articles_on_collection_id'
    end

    create_table 'books', id: :serial do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'description'
      t.text 'buy_url'
      t.text 'buy_info'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'series'
      t.datetime 'published_at', precision: nil
      t.integer 'price_in_cents'
      t.string 'height'
      t.string 'width'
      t.string 'depth'
      t.string 'weight'
      t.string 'pages'
      t.string 'words'
      t.string 'illustrations'
      t.string 'photographs'
      t.string 'printing'
      t.string 'ink'
      t.string 'definitions'
      t.string 'recipes'
      t.boolean 'has_index'
      t.text 'cover_style'
      t.text 'binding_style'
      t.text 'table_of_contents'
      t.boolean 'back_image_present', default: false
      t.boolean 'front_image_present', default: false
      t.boolean 'lite_download_present', default: false
      t.integer 'gallery_images_count'
      t.boolean 'epub_download_present'
      t.boolean 'mobi_download_present'
      t.boolean 'print_black_and_white_a4_download_present'
      t.boolean 'print_color_a4_download_present'
      t.boolean 'print_color_download_present'
      t.boolean 'print_black_and_white_download_present'
      t.boolean 'screen_single_page_view_download_present'
      t.boolean 'screen_two_page_view_download_present'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_books_on_canonical_id'
    end

    create_table 'categories', id: :serial do |t|
      t.string 'name'
      t.string 'slug'

      t.timestamps
    end

    create_table 'categorizations', id: :serial do |t|
      t.integer 'category_id'
      t.integer 'article_id'

      t.timestamps
    end

    create_table 'definitions' do |t|
      t.string 'title'
      t.text 'content'
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.string 'subtitle'
      t.string 'filed_under'
      t.string 'draft_code'
      t.string 'slug'
      t.integer 'publication_status'
      t.datetime 'published_at'
      t.datetime 'featured_at'
      t.boolean 'featured_status', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_definitions_on_canonical_id'
    end

    create_table 'episodes', id: :serial do |t|
      t.integer 'podcast_id', default: 1
      t.string 'title'
      t.string 'subtitle'
      t.text 'image'
      t.string 'content'
      t.text 'audio_mp3_url'
      t.string 'audio_mp3_file_size'
      t.text 'audio_ogg_url'
      t.string 'audio_ogg_file_size'
      t.text 'show_notes'
      t.text 'transcript'
      t.string 'audio_length'
      t.string 'duration'
      t.string 'audio_type', default: 'audio/mpeg'
      t.string 'tags'
      t.datetime 'published_at', precision: nil
      t.string 'slug'
      t.string 'published_at_tz', default: 'Pacific Time (US & Canada)', null: false
      t.string 'episode_number'
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.string 'draft_code'
      t.integer 'publication_status', default: 0, null: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_episodes_on_canonical_id'
      t.index ['podcast_id'], name: 'index_episodes_on_podcast_id'
    end

    create_table 'issues' do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'description'
      t.text 'buy_url'
      t.text 'buy_info'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'series'
      t.datetime 'published_at', precision: nil
      t.integer 'price_in_cents'
      t.string 'height'
      t.string 'width'
      t.string 'depth'
      t.string 'weight'
      t.string 'pages'
      t.string 'words'
      t.string 'illustrations'
      t.string 'photographs'
      t.string 'printing'
      t.string 'ink'
      t.string 'definitions'
      t.string 'recipes'
      t.boolean 'has_index'
      t.text 'cover_style'
      t.text 'binding_style'
      t.text 'table_of_contents'
      t.boolean 'back_image_present', default: false
      t.boolean 'front_image_present', default: false
      t.boolean 'lite_download_present', default: false
      t.integer 'gallery_images_count'
      t.boolean 'epub_download_present'
      t.boolean 'mobi_download_present'
      t.boolean 'print_black_and_white_a4_download_present'
      t.boolean 'print_color_a4_download_present'
      t.boolean 'print_color_download_present'
      t.boolean 'print_black_and_white_download_present'
      t.boolean 'screen_single_page_view_download_present'
      t.boolean 'screen_two_page_view_download_present'
      t.integer 'journal_id'
      t.integer 'issue'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false
      t.datetime 'created_at', precision: nil
      t.datetime 'updated_at', precision: nil

      t.index ['canonical_id'], name: 'index_issues_on_canonical_id'
    end

    create_table 'journals' do |t|
      t.string 'title'
      t.string 'subtitle'
      t.text 'description'
      t.string 'slug'
      t.datetime 'published_at', precision: nil
      t.integer 'publication_status', default: 0, null: false
      t.text 'buy_url'
      t.text 'content'
      t.text 'summary'
      t.text 'buy_info'
      t.integer 'price_in_cents'
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_journals_on_canonical_id'
    end

    create_table 'locales' do |t|
      t.string 'abbreviation'
      t.string 'name_in_english'
      t.string 'name'
      t.integer 'language_direction', default: 0
      t.string 'slug'
      t.integer 'articles_count', default: 0

      t.timestamps
    end

    create_table 'logos' do |t|
      t.string 'slug'
      t.string 'title'
      t.string 'subtitle'
      t.text 'description'
      t.string 'content_format'
      t.datetime 'published_at', precision: nil
      t.text 'summary'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_logos_on_canonical_id'
    end

    create_table 'pages', id: :serial do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'image'
      t.text 'image_description'
      t.text 'css'
      t.string 'header_background_color'
      t.string 'header_text_color'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'draft_code'
      t.datetime 'published_at', precision: nil
      t.string 'published_at_tz', default: 'Pacific Time (US & Canada)', null: false
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'

      t.timestamps

      t.index ['canonical_id'], name: 'index_pages_on_canonical_id'
    end

    create_table 'podcasts', id: :serial do |t|
      t.string 'title'
      t.string 'subtitle'
      t.string 'slug'
      t.string 'language'
      t.string 'copyright'
      t.text 'image'
      t.text 'content'
      t.string 'itunes_author'
      t.string 'itunes_categories'
      t.boolean 'itunes_explicit', default: true
      t.string 'tags'
      t.string 'itunes_summary'
      t.string 'itunes_owner_name'
      t.string 'itunes_owner_email'
      t.text 'itunes_url'
      t.text 'overcast_url'
      t.text 'pocketcasts_url'
      t.string 'episode_prefix'
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'

      t.timestamps

      t.index ['canonical_id'], name: 'index_podcasts_on_canonical_id'
    end

    create_table 'posters' do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.string 'content_format', default: 'kramdown'
      t.text 'buy_info'
      t.text 'buy_url'
      t.integer 'price_in_cents'
      t.text 'summary'
      t.text 'description'
      t.text 'slug'
      t.string 'height'
      t.string 'width'
      t.string 'depth'
      t.string 'front_image_format', default: 'jpg'
      t.string 'back_image_format', default: 'jpg'
      t.datetime 'published_at', precision: nil
      t.boolean 'front_color_image_present'
      t.boolean 'front_black_and_white_image_present'
      t.boolean 'back_color_image_present'
      t.boolean 'back_black_and_white_image_present'
      t.boolean 'front_color_download_present'
      t.boolean 'front_black_and_white_download_present'
      t.boolean 'back_color_download_present'
      t.boolean 'back_black_and_white_download_present'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_posters_on_canonical_id'
    end

    create_table 'redirects', id: :serial do |t|
      t.string 'source_path'
      t.string 'target_path'
      t.boolean 'temporary'
      t.integer 'article_id'

      t.timestamps
    end

    create_table 'stickers' do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.string 'content_format', default: 'kramdown'
      t.text 'buy_info'
      t.text 'buy_url'
      t.integer 'price_in_cents'
      t.text 'summary'
      t.text 'description'
      t.text 'slug'
      t.string 'height'
      t.string 'width'
      t.string 'depth'
      t.string 'front_image_format', default: 'jpg'
      t.string 'back_image_format', default: 'jpg'
      t.datetime 'published_at', precision: nil
      t.boolean 'front_color_image_present'
      t.boolean 'front_black_and_white_image_present'
      t.boolean 'back_color_image_present'
      t.boolean 'back_black_and_white_image_present'
      t.boolean 'front_color_download_present'
      t.boolean 'front_black_and_white_download_present'
      t.boolean 'back_color_download_present'
      t.boolean 'back_black_and_white_download_present'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_stickers_on_canonical_id'
    end

    create_table 'support_sessions' do |t|
      t.string 'stripe_customer_id'
      t.string 'token'
      t.datetime 'expires_at', precision: nil
    end

    create_table 'taggings', id: :serial do |t|
      t.integer 'tag_id'
      t.integer 'taggable_id'
      t.string 'taggable_type'

      t.timestamps
    end

    create_table 'tags', id: :serial do |t|
      t.string 'name'
      t.string 'slug'
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'

      t.timestamps

      t.index ['canonical_id'], name: 'index_tags_on_canonical_id'
      t.index ['name'], name: 'index_tags_on_name', unique: true
    end

    create_table 'users', id: :serial do |t|
      t.string 'username'
      t.string 'password_digest'
      t.integer 'role', default: 0, null: false

      t.timestamps
    end

    create_table 'videos', id: :serial do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'image_description'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'quality'
      t.string 'duration'
      t.string 'vimeo_id'
      t.datetime 'published_at', precision: nil
      t.string 'year'
      t.string 'month'
      t.string 'day'
      t.string 'published_at_tz', default: 'Pacific Time (US & Canada)', null: false
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'

      t.timestamps

      t.index ['canonical_id'], name: 'index_videos_on_canonical_id'
    end

    create_table 'zines' do |t|
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'description'
      t.text 'buy_url'
      t.text 'buy_info'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'series'
      t.datetime 'published_at', precision: nil
      t.integer 'price_in_cents'
      t.string 'height'
      t.string 'width'
      t.string 'depth'
      t.string 'weight'
      t.string 'pages'
      t.string 'words'
      t.string 'illustrations'
      t.string 'photographs'
      t.string 'printing'
      t.string 'ink'
      t.string 'definitions'
      t.string 'recipes'
      t.boolean 'has_index'
      t.text 'cover_style'
      t.text 'binding_style'
      t.text 'table_of_contents'
      t.boolean 'back_image_present', default: false
      t.boolean 'front_image_present', default: false
      t.boolean 'lite_download_present', default: false
      t.integer 'gallery_images_count'
      t.boolean 'epub_download_present'
      t.boolean 'mobi_download_present'
      t.boolean 'print_black_and_white_a4_download_present'
      t.boolean 'print_color_a4_download_present'
      t.boolean 'print_color_download_present'
      t.boolean 'print_black_and_white_download_present'
      t.boolean 'screen_single_page_view_download_present'
      t.boolean 'screen_two_page_view_download_present'
      t.integer 'publication_status', default: 0, null: false
      t.string 'locale', default: 'en'
      t.integer 'canonical_id'
      t.boolean 'featured_status', default: false
      t.datetime 'featured_at', precision: nil
      t.integer 'position'
      t.boolean 'hide_from_index', default: false

      t.timestamps

      t.index ['canonical_id'], name: 'index_zines_on_canonical_id'
    end

    add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
    add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertible'
  end
end
