class AddStatusIdToBook < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :status_id, :integer
  end
end
