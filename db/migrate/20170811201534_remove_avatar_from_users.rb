class RemoveAvatarFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :avatar, :string
  end
end
