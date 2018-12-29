class Journal < ApplicationRecord
  include Tool

  include Name
  include Slug
  include Publishable

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings

  default_scope { order(slug: :asc) }

  belongs_to :series

  NAMESPACE = 'journals'.freeze

  def path
    [nil, NAMESPACE, slug].join('/')
  end

  def image(side: :front, count: 0)
    case side
    when :front
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, "#{slug}_front.jpg"].join('/')
    when :back
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, "#{slug}_back.jpg"].join('/')
    when :gallery
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, 'gallery', "#{slug}-#{count}.jpg"].join('/')
    when :header
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, 'gallery', "#{slug}_header.jpg"].join('/')
    else
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, 'photo.jpg'].join('/')
    end
  end

  def image_description
    "Photo of ‘#{title}’ front cover"
  end
  alias front_image_description image_description

  def back_image_description
    "Photo of ‘#{title}’ back cover"
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
    [Tool::ASSET_BASE_URL, NAMESPACE, slug, filename].join('/')
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

  def downloads_available?
     downloads = []
     I18n.t('downloads.formats').keys.each do |format, _|
       downloads << send("#{format}_download_present")
     end
     downloads.compact.any?
  end

  def ask_for_donation?
    false
  end

  def gallery_images
    if gallery_images_count.present? && gallery_images_count.positive?
      biggest_image = gallery_images_count.to_s.rjust(2, '0')
      ('01'..biggest_image).to_a
    else
      []
    end
  end
end
