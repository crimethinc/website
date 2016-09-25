class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string :name, :slug
      t.text :saved_content
      t.boolean :editable, default: true

      t.string :form_element, default: "text_field"
      t.text :fallback

      t.timestamps
    end
  end
end
