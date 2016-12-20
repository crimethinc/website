class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.string :name, :slug
      t.text   :description

      t.timestamps
    end
  end
end
