class AddSubtitleToDefinitions < ActiveRecord::Migration[6.1]
  def change
    add_column :definitions, :subtitle, :string
  end
end
