class DropContributions < ActiveRecord::Migration[5.1]
  def up
    drop_table :contributions
    drop_table :contributors
  end

  def down
    create_table :contributions do |t|
      t.references :article, foreign_key: true
      t.references :contributor, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end

    create_table :contributors do |t|
      t.string :name
      t.string :photo
      t.text :bio
      t.string :slug

      t.timestamps
    end
  end
end
