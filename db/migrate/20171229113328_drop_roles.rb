class DropRoles < ActiveRecord::Migration[5.1]
  def up
    drop_table :roles
  end

  def down
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    add_index :roles, :name, unique: true
  end
end
