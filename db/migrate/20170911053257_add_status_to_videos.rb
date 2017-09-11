class AddStatusToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :status_id, :integer
  end
end
