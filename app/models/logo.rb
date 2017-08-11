class Logo < ApplicationRecord
  include Name
  include Slug

  default_scope { order("slug ASC") }

  ASSET_BASE_URL = "https://cloudfront.crimethinc.com/assets"
  FORMATS = %w(jpg png pdf svg tif)

  def namespace
    "logos"
  end

  def path
    [nil, namespace, slug].join("/")
  end

  def image_description
    "Photo of '#{title}' logo"
  end
  alias_method :front_image_description, :image_description

  def preview_image_url
    [ASSET_BASE_URL, namespace, slug, "preview.png"].join("/")
  end
  alias_method :front_image, :preview_image_url

  def image_url(extension)
    filename = [slug, ".", extension.to_s].join
    [ASSET_BASE_URL, namespace, slug, filename].join("/")
  end
  alias_method :download_url, :image_url

  def price_in_cents; nil; end
  def buy_info; nil; end
  def back_image_present?; nil; end
  def front_download_present?; nil; end
  def back_download_present?; nil; end
  def depth; nil; end
  def content; nil; end
end











