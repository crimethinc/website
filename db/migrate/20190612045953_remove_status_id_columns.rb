class RemoveStatusIdColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :status_id, :integer
    remove_column :books, :status_id, :integer
    remove_column :journals, :status_id, :integer
    remove_column :logos, :status_id, :integer
    remove_column :pages, :status_id, :integer
    remove_column :posters, :status_id, :integer
    remove_column :stickers, :status_id, :integer
    remove_column :videos, :status_id, :integer
    remove_column :zines, :status_id, :integer
  end
end
