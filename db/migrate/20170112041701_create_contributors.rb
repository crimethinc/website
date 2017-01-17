class CreateContributors < ActiveRecord::Migration[5.0]
  def change
    create_table :contributors do |t|
      t.string :name
      t.string :photo
      t.text :bio
      t.string :slug

      t.timestamps
    end
    add_index :contributors, :slug, unique: true
  end
end
