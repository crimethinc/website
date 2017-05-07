class ArticleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    # This will be the directory path in the CMS
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    model.image
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def filename
    # don't try changing the name if original_filename is missing
    return unless original_filename

    # This will be the filename for all the processed/uploaded images
    model.title.downcase.tr(' ', '_') + File.extname(original_filename)
  end

  version :large do
    process create_sized_image: 1024
  end

  version :medium, from_version: :large do
    process create_sized_image: 640
  end

  version :small, from_version: :medium do
    process create_sized_image: 320
  end

  def create_sized_image(width)
    manipulate! do |img|
      img.filter('Triangle')
      img.define('filter:support=2')
      img.thumbnail(width)
      img.unsharp('0.25x0.08+8.3+0.045')
      img.dither('None')
      img.posterize('136')
      img.quality('82')
      img.define('jpeg:fancy-upsampling=off')
      img.define('png:compression-filter=5')
      img.define('png:compression-level=9')
      img.define('png:compression-strategy=1')
      img.define('png:exclude-chunk=all')
      img.interlace('none')
      img.colorspace('sRGB')
      img = yield(img) if block_given?
      img
    end
  end
end
