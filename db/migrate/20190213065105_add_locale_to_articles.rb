class AddLocaleToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :locale, :string, default: 'en'
  end
end
