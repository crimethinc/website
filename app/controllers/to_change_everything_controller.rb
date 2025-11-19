class ToChangeEverythingController < ApplicationController
  layout 'to_change_everything', only: [:show]

  LTR_TO_CHANGE_ANYTHING_YAMLS = %w[
    srpskohrvatski
    malay
    english
    espanol
    espanol-america-latina
    lietuvos
    portugues
    quebecois
    turkce
    日本語
    ภาษาไทย
    한국어
  ].freeze

  RTL_TO_CHANGE_ANYTHING_YAMLS = %w[
    srpskohrvatski
    فارسی
  ].freeze

  TO_CHANGE_ANYTHING_YAMLS = [
    LTR_TO_CHANGE_ANYTHING_YAMLS + RTL_TO_CHANGE_ANYTHING_YAMLS
  ].flatten.freeze

  def show
    @locale = params[:lang]

    if TO_CHANGE_ANYTHING_YAMLS.include?(@locale)
      I18n.locale = @locale
    else
      I18n.locale = @locale = I18n.default_locale
      redirect_to '/tce'
    end
  end
end
