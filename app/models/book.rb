class Book < ApplicationRecord
  include Name
  include Slug

  scope :book, -> { where(zine: false) }
  scope :zine, -> { where(zine: true)  }

  ASSET_BASE_URL = "https://cloudfront.crimethinc.com/assets"

  def namespace
    zine? ? "zines" : "books"
  end

  def book?
    !zine?
  end

  def path
    [nil, namespace, slug].join("/")
  end

  def image(type, count=0)
    case type
    when :front
      [ASSET_BASE_URL, namespace, slug, "#{slug}_front.jpg"].join("/")
    when :back
      [ASSET_BASE_URL, namespace, slug, "#{slug}_back.jpg"].join("/")
    when :gallery
      [ASSET_BASE_URL, namespace, slug, "gallery", "#{slug}-#{count}.jpg"].join("/")
    when :header
      [ASSET_BASE_URL, namespace, slug, "gallery", "#{slug}_header.jpg"].join("/")
    else
      [ASSET_BASE_URL, namespace, slug, "photo.jpg"].join("/")
    end
  end

  def image_description
    "Photo of '#{title}' front cover"
  end
  alias_method :front_image_description, :image_description

  def back_image_description
    "Photo of '#{title}' back cover"
  end

  def image_description
    "Photo of '#{title}' cover"
  end

  def front_image
    image :front
  end

  def back_image
    iamge :back
  end

  def header_image
    image :header
  end

  def download_url(type=nil)
    filename = [slug]
    filename << "_#{type.to_s}" if type.present?
    filename << ".pdf"
    filename = filename.join
    [ASSET_BASE_URL, namespace, slug, filename].join("/")
  end
end
