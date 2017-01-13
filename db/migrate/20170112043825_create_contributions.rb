class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|
      t.references :article, foreign_key: true
      t.references :contributor, foreign_key: true
      t.references :role, foreign_key: true

      t.timestamps
    end
  end
end
