module ToChangeEverythingHelper
  TCE_IMAGE_BASE_URL = 'https://cloudfront.crimethinc.com/assets/tce/images/'.freeze

  SECTIONS = {
    intro: %w[introduction].freeze,
    first: %w[self answering power relationships reconciling liberation revolt control].freeze,
    last:  %w[hierarchy borders representation leaders government profit property lastcrime].freeze,
    outro: %w[anarchy outro takeflight next].freeze
  }.freeze

  LANGUAGE_LINKS = {
    first: {
      'العربية'                                         => '/2016/09/21/to-change-everything-in-11-more-languages#arabic',
      'հայերեն'                                         => '/2016/09/21/to-change-everything-in-11-more-languages#armenian',
      'Български'                                       => '/2016/09/21/to-change-everything-in-11-more-languages#bulgarian',
      'Cebuano'                                         => '/2016/09/21/to-change-everything-in-11-more-languages#cebuano',
      'Català'                                          => '/2016/01/25/to-change-everything-in-ten-more-languages#catalan',
      '中文'                                              => '/2016/01/25/to-change-everything-in-ten-more-languages#chinese',
      'Czech'                                           => '/tce/czech',
      'Dansk'                                           => '/2016/01/25/to-change-everything-in-ten-more-languages#danish',
      'Deutsch'                                         => '/tce/deutsch',
      'English'                                         => '/tce',
      'Español'                                         => '/tce/espanol',
      'Español<br />&nbsp;&nbsp;&nbsp;(América Latina)' => '/tce/espanol-america-latina',
      'فارسی'                                           => '/tce/فارسی',
      'Français'                                        => '/2016/01/25/to-change-everything-in-ten-more-languages#french',
      'Français (Québec)'                               => '/tce/quebecois'
    }.freeze,

    last:  {
      'ελληνικά'                            => '/2016/01/25/to-change-everything-in-ten-more-languages#greek',
      'Italiano'                            => '/2016/01/25/to-change-everything-in-ten-more-languages#italian',
      '한국어'                                 => '/tce/한국어',
      'Lietuvos'                            => '/tce/lietuvos',
      'Malay'                               => '/2016/09/21/to-change-everything-in-11-more-languages#malay',
      'Malti'                               => '/2016/09/21/to-change-everything-in-11-more-languages#maltese',
      'Nederlands'                          => '/2016/09/21/to-change-everything-in-11-more-languages#dutch',
      '日本語'                                 => '/tce/日本語',
      'Polski'                              => '/tce/polski',
      'Português'                           => '/tce/portugues',
      'Română'                              => '/2016/01/25/to-change-everything-in-ten-more-languages#romanian',
      'русский'                             => '/2016/01/25/to-change-everything-in-ten-more-languages#russian',
      '<!--српскохрватски-->Srpskohrvatski' => '/2016/09/21/to-change-everything-in-11-more-languages#serbocroatian',
      'Slovenčina'                          => '/2016/09/21/to-change-everything-in-11-more-languages#slovakvideo',
      'Slovenščina'                         => '/tce/slovenscina',
      'Svenska'                             => '/2016/01/25/to-change-everything-in-ten-more-languages#swedish',
      'Tagalog'                             => '/2016/09/21/to-change-everything-in-11-more-languages#cebuano'
    }.freeze
  }.freeze

  def tce_table_of_contents_sections
    [SECTIONS[:intro], SECTIONS[:first], SECTIONS[:last], SECTIONS[:outro]].flatten
  end

  def tce_language_links_first
    LANGUAGE_LINKS[:first]
  end

  def tce_language_links_last
    LANGUAGE_LINKS[:last]
  end

  def tce_language_links
    tce_language_links_first.merge tce_language_links_last
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
