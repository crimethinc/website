class AddPublishedAtToPosters < ActiveRecord::Migration[5.1]
  def change
    add_column :posters, :published_at, :datetime
  end
end
