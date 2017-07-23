class ArticleImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    # This will be the directory path in the CMS
    # e.g. assets/articles/YYYY/MM/DD
    date_path = model.path.gsub(model.slug,'')
    "assets/articles/#{date_path}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png svg]
  end

  def filename
    # don't try changing the name if original_filename is missing
    return unless original_filename

    # This will be the filename for all the processed/uploaded images
    # most of the time it will be 'header-1', if there are multiple
    # articles published the same day the integer will increment.    
    "header-#{published_count}"
  end

  version :full_sized do
    process create_sized_image: 2000
  end

  version :large , from_version: :full_sized do
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

  private

  def published_count
    @published_article_count ||= Article.where(
      published_at: model.published_at.beginning_of_day..model.published_at.end_of_day
    ).count
  end
end
