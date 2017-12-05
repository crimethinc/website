class DropThemes < ActiveRecord::Migration[5.1]
  def up
    drop_table :themes

    remove_column :articles, :theme_id
  end

  def down
    create_table :themes do |t|
      t.string :name, :slug
      t.text   :description

      t.timestamps
    end

    add_column :articles, :theme_id, :integer
  end
end