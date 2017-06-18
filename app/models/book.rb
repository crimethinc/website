class Book < ApplicationRecord
  include Name
  include Slug

  scope :book, -> { where(book: true) }
  scope :zine, -> { where(zine: true) }

  ASSET_BASE_URL = "https://cloudfront.crimethinc.com/assets"

  def type
    zine? ? "zines" : "books"
  end

  def path
    if zine?
      "/tools/zines/#{slug}"
    else
      "/books/#{slug}"
    end
  end

  def image
    [ASSET_BASE_URL, type, slug, "photo.jpg"].join("/")
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
    [ASSET_BASE_URL, type, slug, "front.jpg"].join("/")
  end

  def back_image
    [ASSET_BASE_URL, type, slug, "back.jpg"].join("/")
  end

  def download_url(type=nil)
    filename = [slug]
    filename << "__#{type.to_s}" if type.present?
    filename << ".pdf"
    filename = filename.join
    [ASSET_BASE_URL, slug, filename].join("/")
  end
end
