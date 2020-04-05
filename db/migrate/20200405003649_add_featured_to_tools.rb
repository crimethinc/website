class AddFeaturedToTools < ActiveRecord::Migration[6.0]
  def change
    add_column :books,    :featured_status, :boolean, default: false
    add_column :books,    :featured_at,     :datetime
    add_column :issues,   :featured_status, :boolean, default: false
    add_column :issues,   :featured_at,     :datetime
    add_column :posters,  :featured_status, :boolean, default: false
    add_column :posters,  :featured_at,     :datetime
    add_column :stickers, :featured_status, :boolean, default: false
    add_column :stickers, :featured_at,     :datetime
    add_column :zines,    :featured_status, :boolean, default: false
    add_column :zines,    :featured_at,     :datetime
  end
end
