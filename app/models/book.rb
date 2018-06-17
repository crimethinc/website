class Book < ApplicationRecord
  include Name
  include Slug
  include Publishable

  scope :book, -> { where(zine: false) }
  scope :zine, -> { where(zine: true)  }

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings

  default_scope { order(slug: :asc) }

  ASSET_BASE_URL = 'https://cloudfront.crimethinc.com/assets'.freeze

  def namespace
    zine? ? 'zines' : 'books'
  end

  def book?
    !zine?
  end

  def path
    [nil, namespace, slug].join('/')
  end

  def image(side: :front, count: 0)
    case side
    when :front
      [ASSET_BASE_URL, namespace, slug, "#{slug}_front.jpg"].join('/')
    when :back
      [ASSET_BASE_URL, namespace, slug, "#{slug}_back.jpg"].join('/')
    when :gallery
      [ASSET_BASE_URL, namespace, slug, "gallery", "#{slug}-#{count}.jpg"].join('/')
    when :header
      [ASSET_BASE_URL, namespace, slug, "gallery", "#{slug}_header.jpg"].join('/')
    else
      [ASSET_BASE_URL, namespace, slug, 'photo.jpg'].join('/')
    end
  end

  def image_description
    "Photo of ‘#{title}’ front cover"
  end
  alias front_image_description image_description

  def back_image_description
    "Photo of ‘#{title}’ back cover"
  end

  def image_description
    "Photo of ‘#{title}’ cover"
  end

  def front_image
    image side: :front
  end

  def back_image
    image side: :back
  end

  def header_image
    image side: :header
  end

  def download_url(type = nil, extension: 'pdf')
    case type
    when :epub
      type = nil
      extension = 'epub'
    when :mobi
      type = nil
      extension = 'mobi'
    end

    filename = [slug]
    filename << "_#{type}" if type.present?
    filename << '.'
    filename << extension
    filename = filename.join
    [ASSET_BASE_URL, namespace, slug, filename].join('/')
  end

  def meta_description
    if summary.blank?
      html = Kramdown::Document.new(
        content,
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.to_s

      doc = Nokogiri::HTML(html)
      doc.css('body').text.truncate(200)
    else
      summary
    end
  end

  def meta_image
    image side: :front
  end
end
