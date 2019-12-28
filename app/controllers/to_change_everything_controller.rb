class ToChangeEverythingController < ApplicationController
  layout 'to_change_everything', only: [:show]

  TO_CHANGE_ANYTHING_YAMLS = %w[日本語 portugues quebecois espanol-america-latina lietuvos 한국어 english espanol فارسی].freeze

  SECTIONS_INTRO = %w[introduction].freeze
  SECTIONS_FIRST = %w[self answering power relationships reconciling liberation revolt control].freeze
  SECTIONS_LAST  = %w[hierarchy borders representation leaders government profit property lastcrime].freeze
  SECTIONS_OUTRO = %w[anarchy outro takeflight next].freeze

  LANGUAGES_FIRST = {
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
  }.freeze

  LANGUAGES_LAST = {
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

  def show
    @sections_first       = SECTIONS_FIRST
    @sections_last        = SECTIONS_LAST
    @language_links_first = LANGUAGES_FIRST
    @language_links_last  = LANGUAGES_LAST
    @language_links       = @language_links_first.merge @language_links_last

    @locale = params[:lang]

    if TO_CHANGE_ANYTHING_YAMLS.include?(@locale)
      I18n.locale = @locale
    else
      I18n.locale = @locale = I18n.default_locale
      redirect_to '/tce'
    end
  end
end
