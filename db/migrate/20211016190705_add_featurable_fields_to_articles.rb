class AddFeaturableFieldsToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :position, :integer # rubocop:disable Rails/BulkChangeTable
    add_column :articles, :hide_from_index, :boolean, default: false
  end
end
