class RemoveHeaderBackgroundColorFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :header_background_color, :string
  end
end
