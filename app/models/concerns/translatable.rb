module Translatable
  extend ActiveSupport::Concern

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

  def preferred_localization
    localization_in(I18n.locale).presence || self
  end

  def localization_in locale
    self.class.published.live.where(locale: locale).where('id = ? OR canonical_id = ?', canonical_id, id).limit(1).first
  end

  def localizations
    all_localizations = [
      canonical_record,
      canonical_record_localizations,
      self_localizations
    ]

    records = all_localizations.flatten.compact - [self]
    records.sort_by(&:locale)
  end

  def canonical_record
    self.class.find_by(id: canonical_id)
  end

  def canonical_record_localizations
    canonical_record&.localizations
  end

  def self_localizations
    self.class.published.live.where(canonical_id: id)
  end
end
