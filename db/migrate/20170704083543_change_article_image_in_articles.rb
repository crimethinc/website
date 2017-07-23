class ChangeArticleImageInArticles < ActiveRecord::Migration[5.1]
  def change
    change_column :articles, :article_image, :text
  end
end
