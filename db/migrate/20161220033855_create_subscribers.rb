class CreateSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.string :email
      t.string :frequency, default: 'weekly'

      t.timestamps
    end
  end
end
