class Logo < ApplicationRecord
  include Tool

  IMAGE_FORMATS = %w[jpg png pdf svg tif].freeze

  def image_description
    "Photo of ‘#{title}’ logo"
  end
  alias front_image_description image_description

  def front_image
    [asset_base_url_prefix, 'preview.png'].join('/')
  end

  def image_url extension
    filename = [slug, '.', extension.to_s].join
    [asset_base_url_prefix, filename].join('/')
  end
  alias download_url image_url

  def meta_description
    "CrimethInc. logo: #{title}. Size: #{width} x #{height}."
  end

  def meta_image
    image_url :png
  end
  alias image meta_image

  def price_in_cents
    nil
  end

  def buy_info
    nil
  end

  def back_image_present?
    nil
  end

  def front_download_present?
    nil
  end

  def back_download_present?
    nil
  end

  def depth
    nil
  end

  def content
    nil
  end
end
