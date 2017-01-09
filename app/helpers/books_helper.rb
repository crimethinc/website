module BooksHelper
  def thumbnail_link_to_large_image(small_url, large_url=nil)
    if large_url.nil?
      large_url = small_url.sub("small.", "large.")
    end

    link_to(image_tag(small_url), large_url)
  end
end
