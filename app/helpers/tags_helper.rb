module TagsHelper
  attr_accessor :body_id
  attr_accessor :html_id

  def html_dir
    article_locale&.language_direction.presence || t('language_direction')
  end

  def html_lang
    article_locale&.abbreviation.presence || I18n.locale
  end

  def html_prefix
    # For pasted URL previews on Facebook
    'og: http://ogp.me/ns#'
  end

  def html_class
    "#{site_mode}-mode"
  end

  private

  def article_locale
    @article_locale ||= Locale.find_by(abbreviation: @article&.locale)
  end
end
