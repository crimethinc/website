class AddPublicationStatusFieldsToEpisodes < ActiveRecord::Migration[7.0]
  def change
    change_table :episodes, bulk: true do |t|
      t.string  :draft_code
      t.integer :publication_status, default: 0, null: false
    end
  end
end
