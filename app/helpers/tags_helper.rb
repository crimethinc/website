module TagsHelper
  def html_dir
    t 'language_direction'
  end

  def html_lang
    I18n.locale
  end

  def html_prefix
    # For pasted URL previews on Facebook
    'og: http://ogp.me/ns#'
  end

  def html_id
    @html_id
  end

  def html_class
    "#{site_mode}-mode"
  end

  def body_id
    @body_id
  end
end
