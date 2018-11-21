class RemoveBooleanTypeColumnsFromToolsTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :books,    :zine,    :boolean, default: true
    remove_column :zines,    :zine,    :boolean, default: true
    remove_column :posters,  :sticker, :boolean, default: true
    remove_column :stickers, :sticker, :boolean, default: true
  end
end
