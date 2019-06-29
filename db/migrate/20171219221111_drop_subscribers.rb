class DropSubscribers < ActiveRecord::Migration[5.1]
  def up
    drop_table :subscribers
  end

  def down
    create_table :subscribers do |t|
      t.string :email
      t.string :frequency, default: 'weekly'

      t.timestamps
    end
  end
end
