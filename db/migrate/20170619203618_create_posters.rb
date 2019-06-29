class CreatePosters < ActiveRecord::Migration[5.1]
  def change
    create_table :posters do |t|
      t.boolean :sticker
      t.text :title
      t.text :subtitle
      t.text :content
      t.string :content_format, default: 'kramdown'
      t.text :buy_info
      t.text :buy_url
      t.integer :price_in_cents
      t.text :summary
      t.text :description
      t.boolean :front_image_present, default: true
      t.boolean :back_image_present, default: false
      t.boolean :read_download_present, default: false
      t.boolean :print_download_present, default: false
      t.boolean :lite_download_present, default: false
      t.text :slug
      t.string :height
      t.string :width

      t.timestamps
    end
  end
end
