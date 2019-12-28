class LocaleService::Locales # rubocop:disable Style/ClassAndModuleChildren
  Locale = LocaleService::Locale

  LOCALES = [
    # english
    Locale.new(locale: 'english', lang_code: :en, canonical: 'english'),

    # danish
    Locale.new(locale: 'danish', lang_code: :da, canonical: 'dansk'),
    Locale.new(locale: 'dansk',  lang_code: :da, canonical: 'dansk'),

    # spanish
    Locale.new(locale: 'espanol', lang_code: :es, canonical: 'espanol'),
    Locale.new(locale: 'spanish', lang_code: :es, canonical: 'espanol'),
    Locale.new(locale: 'español', lang_code: :es, canonical: 'espanol'),

    # german
    Locale.new(locale: 'deutsch', lang_code: :de, canonical: 'deutsch'),
    Locale.new(locale: 'german',  lang_code: :de, canonical: 'deutsch'),

    # finnish
    Locale.new(locale: 'suomen',  lang_code: :fi, canonical: 'suomen'),
    Locale.new(locale: 'finnish', lang_code: :fi, canonical: 'suomen'),

    # french
    Locale.new(locale: 'français', lang_code: :fr, canonical: 'francais'),
    Locale.new(locale: 'french',   lang_code: :fr, canonical: 'francais'),

    # greek
    Locale.new(locale: 'ελληνικά', lang_code: :gr, canonical: 'ellenika'),
    Locale.new(locale: 'greek',    lang_code: :gr, canonical: 'ellenika'),

    # hebrew
    Locale.new(locale: 'hebrew',   lang_code: :he, canonical: 'ibriyt'),
    Locale.new(locale: 'עִבְרִית', lang_code: :he, canonical: 'ibriyt'),

    # italian
    Locale.new(locale: 'italian',  lang_code: :it, canonical: 'italiano'),
    Locale.new(locale: 'italiano', lang_code: :it, canonical: 'italiano'),

    # portuguese
    Locale.new(locale: 'portuguese', lang_code: :pt, canonical: 'portugues'),
    Locale.new(locale: 'portugués',  lang_code: :pt, canonical: 'portugues'),

    # brazilian portuguese
    Locale.new(locale: 'brazilian portuguese', lang_code: :'pt-br', canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'português brasileiro', lang_code: :'pt-br', canonical: 'portugues-brasileiro'),

    # swedish
    Locale.new(locale: 'swedish', lang_code: :sv, canonical: 'svenska'),
    Locale.new(locale: 'svenska', lang_code: :sv, canonical: 'svenska'),

    # turkish
    Locale.new(locale: 'turkish', lang_code: :tr, canonical: 'turkce'),
    Locale.new(locale: 'türkçe',  lang_code: :tr, canonical: 'turkce')
  ].freeze

  class << self
    def canonical locale:, lang_code: nil
      return LOCALES.find { |locale_instance| locale_instance.locale == locale } if lang_code.blank?

      @indexed_locales.dig(lang_code) || raise_locale_error(locale)
    end

    private

    def index_locales
      @indexed_locales = LOCALES.each_with_object({}) do |locale, hash|
        hash[locale.lang_code] ||= locale
      end
    end

    def raise_locale_error locale
      raise ArgumentError, "No mapping for the locale #{locale} was found. Maybe a mapping needs to be added?"
    end
  end

  index_locales
end
