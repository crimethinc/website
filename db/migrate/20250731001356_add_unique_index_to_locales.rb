class AddUniqueIndexToLocales < ActiveRecord::Migration[8.0]
  def change
    add_index :locales, :abbreviation,    unique: true
    add_index :locales, :name,            unique: true
    add_index :locales, :name_in_english, unique: true
  end
end
