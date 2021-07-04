module ActiveStorageHelper
  def image_variant_by_width image, width
    define = <<~DEFINE.squish
      filter:support=2
      jpeg:fancy-upsampling=off
      png:compression-filter=5
      png:compression-level=9
      png:compression-strategy=1
      png:exclude-chunk=all
    DEFINE

    image.variant filter:     'Triangle',
                  define:     define,
                  thumbnail:  width,
                  unsharp:    '0.25x0.08+8.3+0.045',
                  dither:     'None',
                  posterize:  '136',
                  quality:    '82',
                  interlace:  'none',
                  colorspace: 'sRGB'
  end
end
