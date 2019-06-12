class DropStatuses < ActiveRecord::Migration[5.2]
  def change
    drop_table :statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
