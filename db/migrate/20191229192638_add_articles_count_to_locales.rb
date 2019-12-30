class AddArticlesCountToLocales < ActiveRecord::Migration[6.0]
  def change
    add_column :locales, :articles_count, :integer, default: 0
  end
end
