class RemoveUserFieldsExceptUsername < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :email, :string
    remove_column :users, :display_name, :string
  end
end
