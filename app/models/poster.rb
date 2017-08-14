class Poster < ApplicationRecord
  include Name
  include Slug

  scope :poster,  -> { where(sticker: false) }
  scope :sticker, -> { where(sticker: true)  }

  default_scope { order(slug: :asc) }

  ASSET_BASE_URL = "https://cloudfront.crimethinc.com/assets"

  def namespace
    sticker? ? "stickers" : "posters"
  end

  def poster?
    !sticker?
  end

  def path
    [nil, namespace, slug].join("/")
  end

  def image_description
    "Photo of '#{title}' front side"
  end
  alias_method :front_image_description, :image_description

  def back_image_description
    "Photo of '#{title}' back side"
  end

  def front_image
    [ASSET_BASE_URL, namespace, slug, "#{slug}_front.#{front_image_format}"].join("/")
  end

  def back_image
    [ASSET_BASE_URL, namespace, slug, "#{slug}_back.#{back_image_format}"].join("/")
  end

  def download_url(type=nil)
    filename = [slug]
    filename << "_#{type.to_s}" if type.present?
    filename << ".pdf"
    filename = filename.join
    [ASSET_BASE_URL, namespace, slug, filename].join("/")
  end
end
