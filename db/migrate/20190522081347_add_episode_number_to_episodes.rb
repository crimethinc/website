class AddEpisodeNumberToEpisodes < ActiveRecord::Migration[5.2]
  def up
    add_column :episodes, :episode_number, :string

    Episode.all.each do |episode|
      episode_number = episode.slug.split('-').last
      episode.update episode_number: episode_number
    end
  end

  def down
    remove_column :episodes, :episode_number
  end
end
