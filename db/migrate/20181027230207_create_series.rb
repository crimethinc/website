class CreateSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :series do |t|
      t.string :title
      t.string :subtitle
      t.text   :description

      t.timestamps
    end
  end
end
