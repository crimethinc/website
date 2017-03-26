class ArticleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  # switch to fog to upload images to cloud stuff
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # TODO: figure out how to use the old article#image as a fallback
  def default_url
    model.image
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # TODO: maybe the files should automatically be renamed to use the article title?
  def filename
    model.title.downcase.tr(' ', '_') + File.extname(original_filename) if original_filename
  end

  version :small do
    process :create_sized_image => 320
  end

  version :medium do
    process :create_sized_image => 640
  end

  version :large do
    process :create_sized_image => 1024
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
