class Video < ApplicationRecord
  include SinglePageTool

  def meta_image
    ''
  end

  def download_url
    "https://vimeo.com/#{vimeo_id}#download"
  end
end
