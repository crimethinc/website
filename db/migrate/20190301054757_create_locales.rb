class CreateLocales < ActiveRecord::Migration[5.2]
  def change
    create_table :locales do |t|
      t.string :abbreviation
      t.string :name_in_english
      t.string :name

      t.timestamps
    end
  end
end
