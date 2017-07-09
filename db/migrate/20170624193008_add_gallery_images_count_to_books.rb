class AddGalleryImagesCountToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :gallery_images_count, :integer
  end
end
