class MigrationDeleteImageColumnFromVideos < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :image, :text
  end
end
