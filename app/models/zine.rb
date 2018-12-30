class Zine < ApplicationRecord
  include MultiPageTool

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
end
