class AddArticleIdToRedirects < ActiveRecord::Migration[5.0]
  def change
    change_table :redirects do |t|
      t.integer :article_id
    end
  end
end
