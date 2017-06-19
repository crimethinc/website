class AddBookZineBooleansToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :zine, :boolean, default: false
    add_column :books, :book, :boolean, default: true
    add_column :books, :back_image_present, :boolean, default: false
  end
end
