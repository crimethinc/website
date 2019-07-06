class AddPublishableColumnsToJournals < ActiveRecord::Migration[5.2]
  def change
    add_column :journals, :published_at, :datetime
    add_column :journals, :publication_status, :integer, default: 0, null: false
    add_column :journals, :buy_url, :text
    add_column :journals, :summary, :text
    add_column :journals, :buy_info, :text
    add_column :journals, :price_in_cents, :integer
  end
end
