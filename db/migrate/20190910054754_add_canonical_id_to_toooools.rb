class AddCanonicalIdToToooools < ActiveRecord::Migration[6.0]
  def change
    %i[
      books
      definitions
      episodes
      issues
      journals
      logos
      pages
      podcasts
      posters
      stickers
      tags
      videos
      zines
    ].each do |table_name|
      add_column table_name, :canonical_id, :integer

      add_index table_name, :canonical_id
    end
  end
end
