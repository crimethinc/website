class DropViewsTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :views
  end

  def down
    create_table :views do |t|
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
