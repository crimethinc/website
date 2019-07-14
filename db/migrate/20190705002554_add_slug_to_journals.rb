class AddSlugToJournals < ActiveRecord::Migration[5.2]
  def change
    add_column :journals, :slug, :string
  end
end
