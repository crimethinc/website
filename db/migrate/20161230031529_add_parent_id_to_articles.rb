class AddParentIdToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :collection_id, :integer

    add_index :articles, :collection_id
  end
end
