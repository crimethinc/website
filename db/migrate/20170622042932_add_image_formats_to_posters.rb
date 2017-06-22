class AddImageFormatsToPosters < ActiveRecord::Migration[5.1]
  def change
    add_column :posters, :front_image_format, :string, default: :jpg
    add_column :posters, :back_image_format,  :string, default: :jpg
  end
end
