class AddNotesToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :notes, :text
  end
end
