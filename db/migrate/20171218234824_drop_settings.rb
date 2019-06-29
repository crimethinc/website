class DropSettings < ActiveRecord::Migration[5.1]
  def up
    drop_table :settings
  end

  def down
    create_table :settings do |t|
      t.string :name, :slug
      t.text :saved_content
      t.boolean :editable, default: true

      t.string :form_element, default: 'text_field'
      t.text :fallback

      t.timestamps
    end
  end
end
