class AddStatusIdToLogoAndPoster < ActiveRecord::Migration[5.1]
  def change
    add_column :logos, :status_id, :integer
    add_column :posters, :status_id, :integer
  end
end
