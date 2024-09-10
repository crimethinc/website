class RenameEnumColums < ActiveRecord::Migration[7.2]
  def change
    # users
    rename_column :users, :role,      :old_role
    rename_column :users, :temp_role, :role

    # locales
    rename_column :locales, :language_direction,      :old_language_direction
    rename_column :locales, :temp_language_direction, :language_direction

    # publishables
    rename_column :articles,    :publication_status,      :old_publication_status
    rename_column :articles,    :temp_publication_status, :publication_status

    rename_column :books,       :publication_status,      :old_publication_status
    rename_column :books,       :temp_publication_status, :publication_status

    rename_column :definitions, :publication_status,      :old_publication_status
    rename_column :definitions, :temp_publication_status, :publication_status

    rename_column :episodes,    :publication_status,      :old_publication_status
    rename_column :episodes,    :temp_publication_status, :publication_status

    rename_column :issues,      :publication_status,      :old_publication_status
    rename_column :issues,      :temp_publication_status, :publication_status

    rename_column :journals,    :publication_status,      :old_publication_status
    rename_column :journals,    :temp_publication_status, :publication_status

    rename_column :logos,       :publication_status,      :old_publication_status
    rename_column :logos,       :temp_publication_status, :publication_status

    rename_column :pages,       :publication_status,      :old_publication_status
    rename_column :pages,       :temp_publication_status, :publication_status

    rename_column :posters,     :publication_status,      :old_publication_status
    rename_column :posters,     :temp_publication_status, :publication_status

    rename_column :stickers,    :publication_status,      :old_publication_status
    rename_column :stickers,    :temp_publication_status, :publication_status

    rename_column :videos,      :publication_status,      :old_publication_status
    rename_column :videos,      :temp_publication_status, :publication_status

    rename_column :zines,       :publication_status,      :old_publication_status
    rename_column :zines,       :temp_publication_status, :publication_status
  end
end
