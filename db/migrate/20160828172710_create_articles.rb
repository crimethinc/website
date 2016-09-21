class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text     :title, :subtitle, :content, :css
      t.string   :year, :month, :day, :slug, :code
      t.string   :status, default: "draft"
      t.datetime :published_at
      t.boolean  :pinned, default: false

      t.timestamps
    end
  end
end
