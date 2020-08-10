class Logo < ApplicationRecord
  include Tool
  has_one_attached :image_jpg, dependent: :destroy
  has_one_attached :image_png, dependent: :destroy
  has_one_attached :image_pdf, dependent: :destroy
  has_one_attached :image_svg, dependent: :destroy
  has_one_attached :image_tif, dependent: :destroy

  IMAGE_FORMATS = %i[jpg png tif svg pdf].freeze

  class << self
    def image_formats
      IMAGE_FORMATS
    end
  end

  def image_description
    "Photo of ‘#{title}’ logo"
  end
  alias front_image_description image_description

  def front_image
    Rails.application.routes.url_helpers.rails_blob_path(image_jpg, only_path: true)
  end

  def image_url extension
    filename = [slug, '.', extension.to_s].join
    [asset_base_url_prefix, filename].join('/')
  end
  alias download_url image_url

  def meta_description
    "CrimethInc. logo: #{title}"
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
