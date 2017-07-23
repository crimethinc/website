class AddArticleImageToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :article_image, :string
  end
end
