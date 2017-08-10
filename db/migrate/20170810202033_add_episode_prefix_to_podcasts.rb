class AddEpisodePrefixToPodcasts < ActiveRecord::Migration[5.1]
  def change
    add_column :podcasts, :episode_prefix, :string
  end
end
