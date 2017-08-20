class AddImageMobileToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :image_mobile, :text
  end
end
