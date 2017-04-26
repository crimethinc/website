class AddShadowTextToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :header_shadow_text, :boolean
  end
end
