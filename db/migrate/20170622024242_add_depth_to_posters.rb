class AddDepthToPosters < ActiveRecord::Migration[5.1]
  def change
    add_column :posters, :depth, :string
  end
end
