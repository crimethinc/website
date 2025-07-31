class AddUniqueIndexToPodcasts < ActiveRecord::Migration[8.0]
  def change
    add_index :podcasts, :slug, unique: true
  end
end
