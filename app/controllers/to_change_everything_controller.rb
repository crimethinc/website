class ToChangeEverythingController < ApplicationController
  layout 'to_change_everything', only: [:show]

  TO_CHANGE_ANYTHING_YAMLS = %w[日本語 portugues quebecois espanol-america-latina lietuvos 한국어 english espanol فارسی].freeze

  SECTIONS_FIRST_GROUP = %w[introduction self answering power relationships reconciling liberation revolt control].freeze
  SECTIONS_LAST_GROUP  = %w[hierarchy borders representation leaders government profit property lastcrime anarchy outro takeflight next].freeze

  LANGUAGES_FIRST_GROUP = {
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

  LANGUAGES_LAST_GROUP = {
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
    @locale = params[:lang]

    @sections_first_group = SECTIONS_FIRST_GROUP
    @sections_last_group  = SECTIONS_LAST_GROUP

    if TO_CHANGE_ANYTHING_YAMLS.include?(@locale)
      I18n.locale = @locale
    else
      I18n.locale = @locale = I18n.default_locale
      redirect_to '/tce'
    end
  end
end
