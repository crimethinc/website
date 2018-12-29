class RemoveHeaderShadowTextFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :header_shadow_text, :boolean
  end
end
