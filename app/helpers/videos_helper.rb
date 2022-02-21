module VideosHelper
  def video_image_tag video, preview_width = 1000
    url = url_for(image_variant_by_width(video.image_poster_frame, preview_width))

    image_tag url, class: 'mb-3 rounded d-block'
  end
end
