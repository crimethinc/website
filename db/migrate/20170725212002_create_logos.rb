class CreateLogos < ActiveRecord::Migration[5.1]
  def change
    create_table :logos do |t|
      t.string :slug
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :height
      t.string :width
      t.string :content_format
      t.boolean :jpg_url_present
      t.boolean :png_url_present
      t.boolean :pdf_url_present
      t.boolean :svg_url_present
      t.boolean :tif_url_present
      t.datetime :published_at
      t.text :summary

      t.timestamps
    end
  end
end
