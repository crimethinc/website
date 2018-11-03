class AddStatusFieldToTablesWithStatusId < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :publication_status, :string, default: 'draft'
    add_column :books,    :publication_status, :string, default: 'draft'
    add_column :journals, :publication_status, :string, default: 'draft'
    add_column :logos,    :publication_status, :string, default: 'draft'
    add_column :pages,    :publication_status, :string, default: 'draft'
    add_column :posters,  :publication_status, :string, default: 'draft'
    add_column :videos,   :publication_status, :string, default: 'draft'
  end
end
