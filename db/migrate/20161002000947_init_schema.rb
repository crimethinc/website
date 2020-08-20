class InitSchema < ActiveRecord::Migration[5.0]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension 'plpgsql'
    create_table 'articles', id: :serial do |t|
      t.integer 'user_id'
      t.integer 'status_id'
      t.integer 'theme_id'
      t.text 'title'
      t.text 'subtitle'
      t.text 'content'
      t.text 'tweet'
      t.text 'summary'
      t.text 'image'
      t.text 'image_description'
      t.text 'css'
      t.text 'download_url'
      t.string 'header_background_color'
      t.string 'header_text_color'
      t.string 'content_format', default: 'kramdown'
      t.string 'slug'
      t.string 'draft_code'
      t.datetime 'published_at'
      t.string 'year'
      t.string 'month'
      t.string 'day'
      t.boolean 'hide_layout', default: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['status_id'], name: 'index_articles_on_status_id'
      t.index ['theme_id'], name: 'index_articles_on_theme_id'
      t.index ['user_id'], name: 'index_articles_on_user_id'
    end
    create_table 'categories', id: :serial do |t|
      t.string 'name'
      t.string 'slug'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'categorizations', id: :serial do |t|
      t.integer 'category_id'
      t.integer 'article_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'links', id: :serial do |t|
      t.string 'name'
      t.text 'url'
      t.integer 'user_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id'], name: 'index_links_on_user_id'
    end
    create_table 'pages', id: :serial do |t|
      t.integer 'user_id'
      t.integer 'status_id'
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
      t.datetime 'published_at'
      t.boolean 'hide_header', default: false
      t.boolean 'hide_footer', default: false
      t.boolean 'hide_layout', default: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['status_id'], name: 'index_pages_on_status_id'
      t.index ['user_id'], name: 'index_pages_on_user_id'
    end
    create_table 'settings', id: :serial do |t|
      t.string 'name'
      t.string 'slug'
      t.text 'saved_content'
      t.boolean 'editable', default: true
      t.string 'form_element', default: 'text_field'
      t.text 'fallback'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'statuses', id: :serial do |t|
      t.string 'name'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'taggings', id: :serial do |t|
      t.integer 'tag_id'
      t.integer 'article_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'tags', id: :serial do |t|
      t.string 'name'
      t.string 'slug'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    create_table 'users', id: :serial do |t|
      t.string 'username'
      t.string 'email'
      t.string 'display_name'
      t.string 'password_digest'
      t.text 'avatar'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end
    add_foreign_key 'links', 'users'
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'The initial migration is not revertable'
  end
end
