module ActiveStorageHelper
  def image_variant_by_width image, width
    image.variant resize_to_limit: [width, width],
                  saver:           {
                    strip:   true,
                    quality: 50,
                    shrink:  8
                  }
  end
end
