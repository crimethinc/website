class AddPositionToZines < ActiveRecord::Migration[6.0]
  def change
    add_column :zines,    :position, :integer
    add_column :journals, :position, :integer
    add_column :issues,   :position, :integer
    add_column :posters,  :position, :integer
    add_column :stickers, :position, :integer
    add_column :logos,    :position, :integer

    add_column :zines,    :hide_from_index, :boolean, default: false
    add_column :journals, :hide_from_index, :boolean, default: false
    add_column :issues,   :hide_from_index, :boolean, default: false
    add_column :posters,  :hide_from_index, :boolean, default: false
    add_column :stickers, :hide_from_index, :boolean, default: false
    add_column :logos,    :hide_from_index, :boolean, default: false
  end
end
