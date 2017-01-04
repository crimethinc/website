class CreateAdminBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.text :content
      t.string :slug
      t.text :download_url
      t.integer :price_in_cents
      t.string :tweet
      t.text :summary
      t.string :pages
      t.string :height
      t.string :width
      t.string :depth
      t.string :weight
      t.string :words
      t.string :illustrations
      t.string :photographs
      t.text :cover_style
      t.text :binding_style
      t.text :table_of_contents

      t.timestamps
    end
  end
end
