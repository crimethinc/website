class DropLinks < ActiveRecord::Migration[5.1]
  def up
    drop_table :links
  end

  def down
    create_table :links do |t|
      t.string :name
      t.text :url
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
