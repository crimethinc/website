class AddEbookFormatsToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :epub_download_present, :boolean
    add_column :books, :mobi_download_present, :boolean
  end
end
