class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.text     :title, :subtitle, :content, :css, :image, :image_description
      t.string   :slug, :draft_code
      t.string   :status, default: "draft"
      t.datetime :published_at

      t.boolean  :hide_header, default: false
      t.boolean  :hide_footer, default: false
      t.boolean  :hide_layout, default: false

      t.timestamps
    end
  end
end
