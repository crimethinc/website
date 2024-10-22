class AddPeerTubeUrlToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :peer_tube_url, :text
  end
end
