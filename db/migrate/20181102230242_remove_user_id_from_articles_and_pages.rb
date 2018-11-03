class RemoveUserIdFromArticlesAndPages < ActiveRecord::Migration[5.2]
  def change
    remove_index :articles, :user_id
    remove_index :pages, :user_id

    remove_column :articles, :user_id, :integer
    remove_column :pages, :user_id, :integer
  end
end
