class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.text :title
      t.text :subtitle
      t.text :content
      t.string :slug

      t.timestamps
    end
  end
end
