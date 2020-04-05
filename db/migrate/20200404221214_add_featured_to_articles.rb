class AddFeaturedToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :featured_status, :boolean, default: false
    add_column :articles, :featured_at,     :datetime
  end
end
