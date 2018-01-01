class CreateDefinitions < ActiveRecord::Migration[5.1]
  def change
    create_table :definitions do |t|
      t.string :name
      t.text :content
      t.boolean :image_present

      t.timestamps
    end
  end
end
