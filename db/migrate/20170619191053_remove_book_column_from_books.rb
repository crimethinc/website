class RemoveBookColumnFromBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :book, :boolean
  end
end
