class RemoveFrontBackAttrsOnPoster < ActiveRecord::Migration[5.1]
  def change
    remove_column :posters, :front_image_present, :boolean
    remove_column :posters, :back_image_present, :boolean
    remove_column :posters, :front_download_present, :boolean
    remove_column :posters, :back_download_present, :boolean
  end
end
