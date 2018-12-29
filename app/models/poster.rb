class Poster < ApplicationRecord
  include Name
  include Slug
  include Publishable

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings

  default_scope { order(slug: :asc) }

  NAMESPACE = 'posters'.freeze

  def path
    [nil, NAMESPACE, slug].join('/')
  end

  def image_description
    I18n.t('tools.poster.image_description', title: title)
  end
  alias front_image_description image_description

  def back_image_description
    I18n.t('tools.poster.image_description', title: title)
  end

  def front_color_image
    image side: :front, color: :color
  end

  def front_black_and_white_image
    image side: :front, color: :black_and_white
  end

  def back_color_image
    image side: :back, color: :color
  end

  def back_black_and_white_image
    image side: :back, color: :black_and_white
  end

  def image(side: :front, color: :color)
    filename = [slug, '_', side, '_', color, '.', send("#{side}_image_format")].join
    [Tool::ASSET_BASE_URL, NAMESPACE, slug, filename].join('/')
  end

  def front_image
    if front_color_image_present? || front_black_and_white_image_present?
      front_color_image_present ? front_color_image : front_black_and_white_image
    else
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, "#{slug}_front.#{front_image_format}"].join('/')
    end
  end

  def back_image
    if back_color_image_present? || back_black_and_white_image_present?
      back_color_image_present ? back_color_image : back_black_and_white_image
    else
      [Tool::ASSET_BASE_URL, NAMESPACE, slug, "#{slug}_back.#{back_image_format}"].join('/')
    end
  end

  def download_url(side: nil, color: nil)
    filename = [slug]
    filename << "_#{side}"  if side.present?
    filename << "_#{color}" if color.present?
    filename << '.pdf'
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
    front_image
  end
end
