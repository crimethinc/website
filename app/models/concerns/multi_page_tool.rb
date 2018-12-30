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
end
