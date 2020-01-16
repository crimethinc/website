class LocaleService::Locales # rubocop:disable Style/ClassAndModuleChildren
  Locale = LocaleService::Locale

  LOCALES = [
    # arabic
    Locale.new(locale: 'arabic',      lang_code: :ar, canonical: 'alarabiyawu'),
    Locale.new(locale: 'alarabiyawu', lang_code: :ar, canonical: 'alarabiyawu'),
    Locale.new(locale: 'اَلْعَرَبِيَّةُ', lang_code: :ar, canonical: 'alarabiyawu'),

    # czech
    Locale.new(locale: 'czech', lang_code: :cs, canonical: 'czech'),
    Locale.new(locale: 'czech', lang_code: :cz, canonical: 'czech'),

    # danish
    Locale.new(locale: 'danish', lang_code: :da, canonical: 'dansk'),
    Locale.new(locale: 'dansk',  lang_code: :da, canonical: 'dansk'),

    # english
    Locale.new(locale: 'english', lang_code: :en, canonical: 'english'),

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
    Locale.new(locale: 'francais', lang_code: :fr, canonical: 'francais'),
    Locale.new(locale: 'french',   lang_code: :fr, canonical: 'francais'),

    # greek
    Locale.new(locale: 'ελληνικά', lang_code: :gr, canonical: 'ellenika'),
    Locale.new(locale: 'ellenika', lang_code: :gr, canonical: 'ellenika'),
    Locale.new(locale: 'greek',    lang_code: :gr, canonical: 'ellenika'),

    # hebrew
    Locale.new(locale: 'hebrew',   lang_code: :he, canonical: 'ibriyt'),
    Locale.new(locale: 'ibriyt',   lang_code: :he, canonical: 'ibriyt'),
    Locale.new(locale: 'עִבְרִית', lang_code: :he, canonical: 'ibriyt'),

    # italian
    Locale.new(locale: 'italian',  lang_code: :it, canonical: 'italiano'),
    Locale.new(locale: 'italiano', lang_code: :it, canonical: 'italiano'),

    # portuguese
    Locale.new(locale: 'portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugués',  lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugues',  lang_code: :pt, canonical: 'portugues-brasileiro'),

    # brazilian portuguese
    Locale.new(locale: 'brazilian portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'brazilian-portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'português brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'português-brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugues-brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),

    # swedish
    Locale.new(locale: 'pусский', lang_code: :ru, canonical: 'russkii'),
    Locale.new(locale: 'russian', lang_code: :ru, canonical: 'russkii'),
    Locale.new(locale: 'russkii', lang_code: :ru, canonical: 'russkii'),

    # swedish
    Locale.new(locale: 'swedish', lang_code: :sv, canonical: 'svenska'),
    Locale.new(locale: 'svenska', lang_code: :sv, canonical: 'svenska'),

    # turkish
    Locale.new(locale: 'turkish', lang_code: :tr, canonical: 'turkce'),
    Locale.new(locale: 'türkçe',  lang_code: :tr, canonical: 'turkce'),
    Locale.new(locale: 'turkce',  lang_code: :tr, canonical: 'turkce'),

    # polish
    Locale.new(locale: 'polski', lang_code: :pl, canonical: 'polski'),
    Locale.new(locale: 'polish', lang_code: :pl, canonical: 'polski')
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
