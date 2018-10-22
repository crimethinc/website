module ToChangeEverythingHelper
  TCE_IMAGE_BASE_URL = 'https://cloudfront.crimethinc.com/assets/tce/images/'.freeze
  TCE_SECTIONS       = %w[self answering power relationships reconciling liberation revolt
                          control hierarchy borders representation leaders government profit
                          property lastcrime].freeze

  def tce_sections
    TCE_SECTIONS
  end

  def url_for_tce_image *pieces
    [TCE_IMAGE_BASE_URL, pieces].flatten.join
  end

  def tce_image_tag filename
    image_tag url_for_tce_image(filename)
  end
end
