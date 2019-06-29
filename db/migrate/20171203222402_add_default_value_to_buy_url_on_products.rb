class AddDefaultValueToBuyUrlOnProducts < ActiveRecord::Migration[5.1]
  def change
    change_column_default :books,   :buy_url, from: '', to: nil
    change_column_default :posters, :buy_url, from: '', to: nil
  end
end