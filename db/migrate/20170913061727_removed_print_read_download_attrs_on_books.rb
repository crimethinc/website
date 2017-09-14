class RemovedPrintReadDownloadAttrsOnBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :read_download_present,  :boolean
    remove_column :books, :print_download_present, :boolean
  end
end


