class RemoveNonActiveStorageColumnsFromLogos < ActiveRecord::Migration[6.0]
  def change
    remove_column :logos, :jpg_url_present, :boolean
    remove_column :logos, :png_url_present, :boolean
    remove_column :logos, :pdf_url_present, :boolean
    remove_column :logos, :svg_url_present, :boolean
    remove_column :logos, :tif_url_present, :boolean
    remove_column :logos, :height, :string
    remove_column :logos, :width, :string
  end
end
