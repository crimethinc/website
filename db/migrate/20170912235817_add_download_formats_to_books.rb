class AddDownloadFormatsToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :print_black_and_white_a4_download_present, :boolean
    add_column :books, :print_color_a4_download_present, :boolean
    add_column :books, :print_color_download_present, :boolean
    add_column :books, :print_black_and_white_download_present, :boolean
    add_column :books, :screen_single_page_view_download_present, :boolean
    add_column :books, :screen_two_page_view_download_present, :boolean
  end
end
