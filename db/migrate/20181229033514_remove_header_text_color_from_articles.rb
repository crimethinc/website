class RemoveHeaderTextColorFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :header_text_color, :string
  end
end
