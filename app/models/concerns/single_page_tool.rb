module SinglePageTool
  extend ActiveSupport::Concern
  include Tool
  include Featureable

  included do
    scope :english,      -> { where(locale: 'en') }
    scope :translation,  -> { where.not(locale: 'en') }
  end

  def english?
    locale == 'en'
  end

  def id_and_name
    "#{id} — #{name}"
  end

  def image_description
    I18n.t('tools.poster.image_description', title: title)
  end
  alias front_image_description image_description

  def back_image_description
    I18n.t('tools.poster.image_description', title: title)
  end

  def front_color_image
    image side: :front, color: :color
  end

  def front_black_and_white_image
    image side: :front, color: :black_and_white
  end

  def back_color_image
    image side: :back, color: :color
  end

  def back_black_and_white_image
    image side: :back, color: :black_and_white
  end

  def image side: :front, color: :color
    if send("#{side}_#{color}_image_present?")
      filename = [slug, '_', side, '_', color, '.', send("#{side}_image_format")].join
      return [asset_base_url_prefix, filename].join('/')
    end

    file_name = []
    file_name << slug
    file_name << '_'

    file_name <<
      if front_color_image_present?
        'front_color'
      elsif front_black_and_white_image_present?
        'front_black_and_white'
      elsif back_color_image_present?
        'back_color'
      elsif back_black_and_white_image_present?
        'back_black_and_white'
      end

    file_name << '.'
    file_name << send("#{side}_image_format")

    [asset_base_url_prefix, file_name.join].join('/')
  end

  def front_image
    front_image_present? ? preferred_front_image : fallback_image_url(side: :front)
  end

  def back_image
    back_image_present? ? preferred_back_image : fallback_image_url(side: :back)
  end

  def fallback_image_url side:
    [asset_base_url_prefix, "#{slug}_#{side}.#{send("#{side}_image_format")}"].join('/')
  end

  def preferred_front_image
    front_color_image_present ? front_color_image : front_black_and_white_image
  end

  def preferred_back_image
    back_color_image_present ? back_color_image : back_black_and_white_image
  end

  def front_image_present?
    front_color_image_present? || front_black_and_white_image_present?
  end

  def back_image_present?
    back_color_image_present? || back_black_and_white_image_present?
  end

  def download_url side: nil, color: nil
    filename = [slug]
    filename << "_#{side}"  if side.present?
    filename << "_#{color}" if color.present?
    filename << '.pdf'
    filename = filename.join
    [asset_base_url_prefix, filename].join('/')
  end

  def meta_image
    front_image
  end

  def preferred_localization
    localization_in(I18n.locale).presence || self
  end

  def localization_in locale
    self.class.published.live.where(locale: locale).where('id = ? OR canonical_id = ?', canonical_id, id).limit(1).first
  end

  def localizations
    all_localizations = [
      canonical_tool,
      canonical_tool_localizations,
      self_localizations
    ]

    tools = all_localizations.flatten.compact - [self]

    tools.sort_by(&:locale)
  end

  def canonical_tool
    self.class.find_by(id: canonical_id)
  end

  def canonical_tool_localizations
    canonical_tool&.localizations
  end

  def self_localizations
    self.class.published.live.where(canonical_id: id)
  end
end
