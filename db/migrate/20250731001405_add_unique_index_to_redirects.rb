class AddUniqueIndexToRedirects < ActiveRecord::Migration[8.0]
  def change
    add_index :redirects, :source_path, unique: true
  end
end
