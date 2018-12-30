class Journal < ApplicationRecord
  include MultiPageTool

  belongs_to :series

  def image(side: :front, count: 0)
    case side
    when :front
      [asset_base_url_prefix, "#{slug}_front.jpg"].join('/')
    when :back
      [asset_base_url_prefix, "#{slug}_back.jpg"].join('/')
    when :gallery
      [asset_base_url_prefix, 'gallery', "#{slug}-#{count}.jpg"].join('/')
    when :header
      [asset_base_url_prefix, 'gallery', "#{slug}_header.jpg"].join('/')
    else
      [asset_base_url_prefix, 'photo.jpg'].join('/')
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
    [asset_base_url_prefix, filename].join('/')
  end
end
