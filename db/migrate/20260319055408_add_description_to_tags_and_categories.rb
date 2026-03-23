class AddDescriptionToTagsAndCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :tags, :description, :text
    add_column :categories, :description, :text
  end
end
