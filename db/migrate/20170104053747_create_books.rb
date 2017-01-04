class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.text       :title, :subtitle, :content, :tweet, :summary
      t.text       :download_url, :buy_url, :description
      t.string     :content_format, default: "kramdown"
      t.string     :slug
      t.datetime   :published_at
      t.integer    :price_in_cents
      t.string     :height, :width, :depth, :weight
      t.string     :pages, :words, :illustrations, :photographs
      t.string     :printing, :ink, :definitions, :recipes
      t.boolean    :has_index
      t.text       :cover_style, :binding_style
      t.text       :table_of_contents

      t.timestamps
    end
  end
end
