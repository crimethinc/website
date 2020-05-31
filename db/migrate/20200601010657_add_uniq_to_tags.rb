class AddUniqToTags < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, :name, unique: true
  end
end
