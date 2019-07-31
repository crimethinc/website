class AddLanguageDirectionToLocale < ActiveRecord::Migration[5.2]
  def change
    add_column :locales, :language_direction, :integer, default: 0
  end
end
