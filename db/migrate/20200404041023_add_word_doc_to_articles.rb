class AddWordDocToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :word_doc, :text
  end
end
