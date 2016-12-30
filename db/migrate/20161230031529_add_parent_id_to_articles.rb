class AddParentIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :parent_id, :integer

    add_index :articles, :parent_id
  end
end
