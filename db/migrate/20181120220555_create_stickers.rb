class CreateStickers < ActiveRecord::Migration[5.2]
  def change
    create_table :stickers do |t|
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
      t.integer "publication_status", default: 0, null: false
      t.timestamps
    end
  end
end
