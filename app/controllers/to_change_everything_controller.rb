class ToChangeEverythingController < ApplicationController
  layout 'to_change_everything', only: [:show]

  TO_CHANGE_ANYTHING_YAMLS = %w[日本語 portugues quebecois espanol-america-latina lietuvos 한국어 english espanol فارسی].freeze

  SECTIONS_FIRST_GROUP = %w[introduction self answering power relationships reconciling liberation revolt control].freeze
  SECTIONS_LAST_GROUP  = %w[hierarchy borders representation leaders government profit property lastcrime anarchy outro takeflight next].freeze

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
