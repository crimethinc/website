class AddHeaderBackgroundColorAndHeaderTextColorToArticle < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :header_background_color, :string
    add_column :articles, :header_text_color, :string
  end
end
