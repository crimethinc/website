module MultiPageTool
  extend ActiveSupport::Concern
  include Tool

  def gallery_images
    if gallery_images_count.present? && gallery_images_count.positive?
      biggest_image = gallery_images_count.to_s.rjust(2, '0')
      ('01'..biggest_image).to_a
    else
      []
    end
  end

  def downloads_available?
    downloads = []
    I18n.t('downloads.formats').each_key do |format, _|
      downloads << send("#{format}_download_present")
    end
    downloads.compact.any?
  end

  def meta_image
    image side: :front
  end

  def download_url type = nil, extension: 'pdf'
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

  def image side: :front, count: 0
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
