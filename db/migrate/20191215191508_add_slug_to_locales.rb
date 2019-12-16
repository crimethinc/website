class AddSlugToLocales < ActiveRecord::Migration[6.0]
  def change
    add_column :locales, :slug, :string
  end
end
