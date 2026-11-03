module ToChangeEverythingHelper
  IMAGE_BASE_URL = 'https://cdn.crimethinc.com/assets/tce/images/'.freeze

  SECTIONS = {
    intro: %w[intro].freeze,
    first: %w[self answering power relationships reconciling liberation revolt control].freeze,
    last:  %w[hierarchy borders representation leaders government profit property lastcrime].freeze,
    outro: %w[anarchy outro takeflight next].freeze
  }.freeze

  LANGUAGE_LINKS = [
    ['العربية' ,'/2016/09/21/to-change-everything-in-11-more-languages#arabic'],
    ['հայերեն', '/2016/09/21/to-change-everything-in-11-more-languages#armenian'],
    ['Български', '/2016/09/21/to-change-everything-in-11-more-languages#bulgarian'],
    ['Cebuano', '/tce/cebuano'],
    ['Català', '/2016/01/25/to-change-everything-in-ten-more-languages#catalan'],
    ['中文', '/2016/01/25/to-change-everything-in-ten-more-languages#chinese'],
    ['Czech', '/tce/czech'],
    ['Dansk', '/2016/01/25/to-change-everything-in-ten-more-languages#danish'],
    ['Deutsch', '/tce/deutsch'],
    ['English', '/tce'],
    ['Español', '/tce/espanol'],
    ['Español (América Latina)', '/tce/espanol-america-latina'],
    ['فارسی', '/tce/فارسی'],
    ['Français', '/2016/01/25/to-change-everything-in-ten-more-languages#french'],
    ['Français (Québec)', '/tce/quebecois'],
    ['ελληνικά', '/2016/01/25/to-change-everything-in-ten-more-languages#greek'],
    ['Italiano', '/tce/italiano'],
    ['한국어', '/tce/한국어'],
    ['Lietuvos', '/tce/lietuvos'],
    ['Malay', '/tce/malay'],
    ['Malti', '/2016/09/21/to-change-everything-in-11-more-languages#maltese'],
    ['Nederlands', '/2016/09/21/to-change-everything-in-11-more-languages#dutch'],
    ['日本語', '/tce/日本語'],
    ['Polski', '/tce/polski'],
    ['Português', '/tce/portugues'],
    ['Română', '/2016/01/25/to-change-everything-in-ten-more-languages#romanian'],
    ['русский', '/2016/01/25/to-change-everything-in-ten-more-languages#russian'],
    ['Srpskohrvatski', '/tce/srpskohrvatski'],
    ['Slovenčina', '/2016/09/21/to-change-everything-in-11-more-languages#slovakvideo'],
    ['Slovenščina', '/tce/slovenscina'],
    ['Türkçe', '/tce/turkce'],
    ['Svenska', '/2016/01/25/to-change-everything-in-ten-more-languages#swedish'],
    ['ภาษาไทย', '/tce/ภาษาไทย']
  ].to_h.freeze

  def tce_table_of_contents_sections = [SECTIONS[:intro], SECTIONS[:first], SECTIONS[:last], SECTIONS[:outro]].flatten
  def tce_language_links = LANGUAGE_LINKS
  def tce_body_sections = [SECTIONS[:first], SECTIONS[:last]].flatten
  def url_for_tce_image(*pieces) = [IMAGE_BASE_URL, pieces].join
  def tce_image_tag(filename) = image_tag url_for_tce_image filename
end
