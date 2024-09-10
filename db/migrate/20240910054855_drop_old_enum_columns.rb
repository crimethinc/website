class DropOldEnumColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :users,       :old_role,               :integer, default: 0, null: false
    remove_column :locales,     :old_language_direction, :integer, default: 0

    remove_column :definitions, :old_publication_status, :integer

    remove_column :articles,    :old_publication_status, :integer, default: 0, null: false
    remove_column :books,       :old_publication_status, :integer, default: 0, null: false
    remove_column :episodes,    :old_publication_status, :integer, default: 0, null: false
    remove_column :issues,      :old_publication_status, :integer, default: 0, null: false
    remove_column :journals,    :old_publication_status, :integer, default: 0, null: false
    remove_column :logos,       :old_publication_status, :integer, default: 0, null: false
    remove_column :pages,       :old_publication_status, :integer, default: 0, null: false
    remove_column :posters,     :old_publication_status, :integer, default: 0, null: false
    remove_column :stickers,    :old_publication_status, :integer, default: 0, null: false
    remove_column :videos,      :old_publication_status, :integer, default: 0, null: false
    remove_column :zines,       :old_publication_status, :integer, default: 0, null: false
  end
end
