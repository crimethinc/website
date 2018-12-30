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
    I18n.t('downloads.formats').keys.each do |format, _|
      downloads << send("#{format}_download_present")
    end
    downloads.compact.any?
  end

  def meta_image
    image side: :front
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
