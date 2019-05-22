class AddEpisodeNumberToEpisodes < ActiveRecord::Migration[5.2]
  def change
    add_column :episodes, :episode_number, :string
  end
end
