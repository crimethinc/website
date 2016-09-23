class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :name
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
