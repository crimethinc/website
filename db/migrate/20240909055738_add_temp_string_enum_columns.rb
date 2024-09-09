class AddTempStringEnumColumns < ActiveRecord::Migration[7.2]
  def change
    add_column :users,       :temp_roles,              :string, null: true
    add_column :locales,     :temp_language_direction, :string, null: true
    add_column :articles,    :temp_publication_status, :string, null: true
    add_column :books,       :temp_publication_status, :string, null: true
    add_column :definitions, :temp_publication_status, :string, null: true
    add_column :episodes,    :temp_publication_status, :string, null: true
    add_column :issues,      :temp_publication_status, :string, null: true
    add_column :journals,    :temp_publication_status, :string, null: true
    add_column :logos,       :temp_publication_status, :string, null: true
    add_column :pages,       :temp_publication_status, :string, null: true
    add_column :posters,     :temp_publication_status, :string, null: true
    add_column :stickers,    :temp_publication_status, :string, null: true
    add_column :videos,      :temp_publication_status, :string, null: true
    add_column :zines,       :temp_publication_status, :string, null: true
  end
end
