class DefaultPodcastIdToOnEpisodes < ActiveRecord::Migration[5.1]
  def change
    change_column_default :episodes, :podcast_id, from: nil, to: 1
  end
end