class AddPositionToBooks < ActiveRecord::Migration[6.0]
  def up
    add_column :books, :position, :integer
    add_column :books, :hide_from_index, :boolean, default: false
  end

  def down
    remove_column :books, :position, :integer
    remove_column :books, :hide_from_index, :boolean, default: false
  end
end
