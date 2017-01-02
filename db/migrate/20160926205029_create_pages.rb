class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.references :user
      t.references :status

      t.text       :title, :subtitle, :content, :tweet, :summary
      t.text       :image, :image_description, :css
      t.string     :header_background_color, :header_text_color
      t.string     :content_format, default: "kramdown"

      t.string     :slug, :draft_code
      t.datetime   :published_at

      t.boolean    :hide_header, default: false
      t.boolean    :hide_footer, default: false
      t.boolean    :hide_layout, default: false

      t.timestamps
    end
  end
end
