module ToChangeEverythingHelper
  TCE_IMAGE_BASE_URL = 'https://cloudfront.crimethinc.com/assets/tce/images/'.freeze

  SECTIONS = {
    intro: %w[introduction].freeze,
    first: %w[self answering power relationships reconciling liberation revolt control].freeze,
    last:  %w[hierarchy borders representation leaders government profit property lastcrime].freeze,
    outro: %w[anarchy outro takeflight next].freeze
  }.freeze

  def tce_table_of_contents_sections
    [SECTIONS[:intro], SECTIONS[:first], SECTIONS[:last], SECTIONS[:outro]].flatten
  end

  def tce_body_sections
    [tce_body_sections_first, tce_body_sections_last].flatten
  end

  def tce_body_sections_first
    SECTIONS[:first]
  end

  def tce_body_sections_last
    SECTIONS[:last]
  end

  def url_for_tce_image *pieces
    [TCE_IMAGE_BASE_URL, pieces].flatten.join
  end

  def tce_image_tag filename
    image_tag url_for_tce_image(filename)
  end
end
