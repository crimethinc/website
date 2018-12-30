class Logo < ApplicationRecord
  include Tool

  include Slug
  include Publishable

  def image_description
    "Photo of ‘#{title}’ logo"
  end
  alias front_image_description image_description

  def preview_image_url
    [asset_base_url_prefix, 'preview.png'].join('/')
  end
  alias front_image preview_image_url

  def image_url(extension)
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
