class RenameDownloadFieldsOnPoster < ActiveRecord::Migration[5.1]
  def change
    rename_column :posters, :read_download_present,  :front_download_present
    rename_column :posters, :print_download_present, :back_download_present
    remove_column :posters, :lite_download_present,  :text
  end
end
