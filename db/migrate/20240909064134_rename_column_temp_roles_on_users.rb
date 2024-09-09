class RenameColumnTempRolesOnUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :temp_roles, :temp_role
  end
end
