class DropImagePresentFromDefinitions < ActiveRecord::Migration[6.1]
  def change
    remove_column :definitions, :image_present, :boolean
  end
end
