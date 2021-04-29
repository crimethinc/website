class AddPublishingColumnsToDefinitions < ActiveRecord::Migration[6.1]
  def change
    rename_column :definitions, :name, :title
    remove_column :definitions, :image_present, :boolean

    change_table :definitions, bulk: true do |t|
      t.string :subtitle, :filed_under, :draft_code, :slug
      t.integer :publication_status
      t.datetime :published_at, :featured_at
      t.boolean :featured_status, default: false
    end
  end
end
