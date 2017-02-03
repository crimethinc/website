class AddShortPathToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :short_path, :string
  end
end
