class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text     :title, :subtitle, :content, :css
      t.string   :year, :month, :day, :slug, :code, :page_path
      t.string   :status, default: "draft"
      t.datetime :published_at
      t.boolean  :pinned, default: false
      t.boolean  :page, default: false
      t.boolean  :hide_header, default: false
      t.boolean  :hide_footer, default: false

      t.timestamps
    end
  end
end
