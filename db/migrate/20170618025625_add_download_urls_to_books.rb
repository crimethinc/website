class AddDownloadUrlsToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :read_download_present,  :boolean, default: false
    add_column :books, :print_download_present, :boolean, default: false
    add_column :books, :lite_download_present,  :boolean, default: false

    remove_column :books, :download_url, :text
  end
end
