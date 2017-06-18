class AddBookZineBooleansToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :zine, :boolean
    add_column :books, :book, :boolean
    add_column :books, :back_image_present, :boolean, default: false
  end
end
