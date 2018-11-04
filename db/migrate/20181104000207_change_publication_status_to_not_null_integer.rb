class ChangePublicationStatusToNotNullInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :publication_status, :string, default: 'draft'
    remove_column :books,    :publication_status, :string, default: 'draft'
    remove_column :journals, :publication_status, :string, default: 'draft'
    remove_column :logos,    :publication_status, :string, default: 'draft'
    remove_column :pages,    :publication_status, :string, default: 'draft'
    remove_column :posters,  :publication_status, :string, default: 'draft'
    remove_column :videos,   :publication_status, :string, default: 'draft'

    add_column :articles, :publication_status, :integer, default: 'draft', null: false
    add_column :books,    :publication_status, :integer, default: 'draft', null: false
    add_column :journals, :publication_status, :integer, default: 'draft', null: false
    add_column :logos,    :publication_status, :integer, default: 'draft', null: false
    add_column :pages,    :publication_status, :integer, default: 'draft', null: false
    add_column :posters,  :publication_status, :integer, default: 'draft', null: false
    add_column :videos,   :publication_status, :integer, default: 'draft', null: false
  end
end
