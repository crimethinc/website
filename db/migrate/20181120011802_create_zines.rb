class CreateZines < ActiveRecord::Migration[5.2]
  def change
    create_table :zines do |t|
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
      t.datetime 'published_at'
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
      t.boolean 'zine', default: true
      t.boolean 'back_image_present', default: false
      t.boolean 'front_image_present', default: false
      t.boolean 'lite_download_present', default: false
      t.integer 'gallery_images_count'
      t.boolean 'epub_download_present'
      t.boolean 'mobi_download_present'
      t.integer 'status_id'
      t.boolean 'print_black_and_white_a4_download_present'
      t.boolean 'print_color_a4_download_present'
      t.boolean 'print_color_download_present'
      t.boolean 'print_black_and_white_download_present'
      t.boolean 'screen_single_page_view_download_present'
      t.boolean 'screen_two_page_view_download_present'
      t.integer 'publication_status', default: 0, null: false

      t.timestamps
    end
  end
end
