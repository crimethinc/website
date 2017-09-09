class AddFrontBackFieldsToPoster < ActiveRecord::Migration[5.1]
  def change
    add_column :posters, :front_color_image_present, :boolean
    add_column :posters, :front_black_and_white_image_present, :boolean
    add_column :posters, :back_color_image_present, :boolean
    add_column :posters, :back_black_and_white_image_present, :boolean
    add_column :posters, :front_color_download_present, :boolean
    add_column :posters, :front_black_and_white_download_present, :boolean
    add_column :posters, :back_color_download_present, :boolean
    add_column :posters, :back_black_and_white_download_present, :boolean
  end
end