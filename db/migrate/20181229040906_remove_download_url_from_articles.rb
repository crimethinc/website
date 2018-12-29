class RemoveDownloadUrlFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :download_url, :text
  end
end
