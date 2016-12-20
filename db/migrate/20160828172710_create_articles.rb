class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.references :user
      t.references :status
      t.references :theme

      t.text       :title, :subtitle, :content, :css, :image, :image_description
      t.string     :header_background_color, :header_text_color
      t.string     :content_format, default: "kramdown"

      t.string     :slug, :draft_code
      t.datetime   :published_at

      t.string   :year, :month, :day

      t.timestamps
    end
  end
end
