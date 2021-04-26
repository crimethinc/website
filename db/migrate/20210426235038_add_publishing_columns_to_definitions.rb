class AddPublishingColumnsToDefinitions < ActiveRecord::Migration[6.1]
  def change
    change_table :definitions, bulk: true do |t|
      t.string :filed_under, :draft_code, :slug, :string
      t.integer :publication_status
      t.datetime :published_at
    end
  end
end
