class CreateRedirects < ActiveRecord::Migration[5.0]
  def change
    create_table :redirects do |t|
      t.string :source_path
      t.string :target_path
      t.boolean :temporary

      t.timestamps
    end
  end
end
