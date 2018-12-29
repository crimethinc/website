class RemoveHideFieldsFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :hide_layout, :boolean, default: false
    remove_column :pages,    :hide_header, :boolean, default: false
    remove_column :pages,    :hide_footer, :boolean, default: false
    remove_column :pages,    :hide_layout, :boolean, default: false
  end
end
