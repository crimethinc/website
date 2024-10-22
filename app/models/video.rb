class Video < ApplicationRecord
  include Tool

  has_one_attached :image_poster_frame

  alias image image_poster_frame

  def meta_image
    ''
  end

  def download_url
    "https://vimeo.com/#{vimeo_id}#download"
  end

  def video_url
    peer_tube_url.presence || "https://vimeo.com/#{vimeo_id}"
  end
end
