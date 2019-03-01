class AddCanonicalIdToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :canonical_id, :integer

    add_index :articles, :canonical_id
  end
end
