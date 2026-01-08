class LocaleService::Locales # rubocop:disable Style/ClassAndModuleChildren
  Locale = LocaleService::Locale

  LOCALES = [
    # ar: arabic
    Locale.new(locale: 'arabic',      lang_code: :ar, canonical: 'alarabiyawu'),
    Locale.new(locale: 'alarabiyawu', lang_code: :ar, canonical: 'alarabiyawu'),
    Locale.new(locale: 'اَلْعَرَبِيَّةُ', lang_code: :ar, canonical: 'alarabiyawu'),

    # be: belarusian
    Locale.new(locale: 'belarusian', lang_code: :be, canonical: 'bielaruskaia-mova'),
    Locale.new(locale: 'беларуская мова', lang_code: :be, canonical: 'bielaruskaia-mova'),
    Locale.new(locale: 'bielaruskaia-mova', lang_code: :be, canonical: 'bielaruskaia-mova'),

    # bg: bulgarian
    Locale.new(locale: 'bulgarian', lang_code: :bg, canonical: 'blgharski'),
    Locale.new(locale: 'български', lang_code: :bg, canonical: 'blgharski'),
    Locale.new(locale: 'blgharski', lang_code: :bg, canonical: 'blgharski'),

    # bn: bengali
    Locale.new(locale: 'bengali', lang_code: :bn, canonical: 'baanlaa'),
    Locale.new(locale: 'baanlaa', lang_code: :bn, canonical: 'baanlaa'),
    Locale.new(locale: 'বাংলা', lang_code: :bn, canonical: 'baanlaa'),

    # ca: catalan
    Locale.new(locale: 'catalan', lang_code: :ca, canonical: 'catala'),
    Locale.new(locale: 'català',  lang_code: :ca, canonical: 'catala'),
    Locale.new(locale: 'catala',  lang_code: :ca, canonical: 'catala'),

    # cs: czech
    Locale.new(locale: 'czech',   lang_code: :cs, canonical: 'cestina'),
    Locale.new(locale: 'čeština', lang_code: :cs, canonical: 'cestina'),
    Locale.new(locale: 'cestina', lang_code: :cs, canonical: 'cestina'),

    # da: danish
    Locale.new(locale: 'danish', lang_code: :da, canonical: 'dansk'),
    Locale.new(locale: 'dansk',  lang_code: :da, canonical: 'dansk'),

    # de: german
    Locale.new(locale: 'deutsch', lang_code: :de, canonical: 'deutsch'),
    Locale.new(locale: 'german',  lang_code: :de, canonical: 'deutsch'),

    # dv: maldivian
    Locale.new(locale: 'maldivian', lang_code: :dv, canonical: 'dhivehi'),
    Locale.new(locale: 'dhivehi',   lang_code: :dv, canonical: 'dhivehi'),
    Locale.new(locale: 'ދިވެހި', lang_code: :dv, canonical: 'dhivehi'),

    # en: english
    Locale.new(locale: 'english', lang_code: :en, canonical: 'english'),

    # es: spanish
    Locale.new(locale: 'espanol', lang_code: :es, canonical: 'espanol'),
    Locale.new(locale: 'spanish', lang_code: :es, canonical: 'espanol'),
    Locale.new(locale: 'español', lang_code: :es, canonical: 'espanol'),

    # es-419: spanish in the americas
    Locale.new(locale: 'espanol-en-las-americas', lang_code: :'es-419', canonical: 'espanol-en-las-americas'),
    Locale.new(locale: 'espanol-america-latina',  lang_code: :'es-419', canonical: 'espanol-en-las-americas'),
    Locale.new(locale: 'spanish-in-the-americas', lang_code: :'es-419', canonical: 'espanol-en-las-americas'),
    Locale.new(locale: 'espanol-en-las-americas', lang_code: :'es-419', canonical: 'espanol-en-las-americas'),

    # eu: basque
    Locale.new(locale: 'euskara', lang_code: :eu, canonical: 'euskara'),
    Locale.new(locale: 'basque',  lang_code: :eu, canonical: 'euskara'),

    # fa: farsi
    Locale.new(locale: 'farsi', lang_code: :fa, canonical: 'frsy'),
    Locale.new(locale: 'frsy',  lang_code: :fa, canonical: 'frsy'),
    Locale.new(locale: 'فارسی', lang_code: :fa, canonical: 'frsy'),

    # fi: finnish
    Locale.new(locale: 'suomi',   lang_code: :fi, canonical: 'suomen'),
    Locale.new(locale: 'suomen',  lang_code: :fi, canonical: 'suomen'),
    Locale.new(locale: 'finnish', lang_code: :fi, canonical: 'suomen'),

    # fr: french
    Locale.new(locale: 'français', lang_code: :fr, canonical: 'francais'),
    Locale.new(locale: 'francais', lang_code: :fr, canonical: 'francais'),
    Locale.new(locale: 'french',   lang_code: :fr, canonical: 'francais'),

    # gl: galician
    Locale.new(locale: 'galician', lang_code: :gl, canonical: 'gallego'),
    Locale.new(locale: 'gallego',  lang_code: :gl, canonical: 'gallego'),

    # gr: greek
    Locale.new(locale: 'ελληνικά', lang_code: :gr, canonical: 'ellenika'),
    Locale.new(locale: 'ellenika', lang_code: :gr, canonical: 'ellenika'),
    Locale.new(locale: 'greek',    lang_code: :gr, canonical: 'ellenika'),

    # he: hebrew
    Locale.new(locale: 'hebrew',   lang_code: :he, canonical: 'ibriyt'),
    Locale.new(locale: 'ibriyt',   lang_code: :he, canonical: 'ibriyt'),
    Locale.new(locale: 'עִבְרִית', lang_code: :he, canonical: 'ibriyt'),

    # hu: hungarian
    Locale.new(locale: 'hungarian', lang_code: :hu, canonical: 'magyar'),
    Locale.new(locale: 'magyar', lang_code: :hu, canonical: 'magyar'),

    # id: indonesian
    Locale.new(locale: 'indonesian',       lang_code: :id, canonical: 'bahasa-indonesia'),
    Locale.new(locale: 'bahasa-indonesia', lang_code: :id, canonical: 'bahasa-indonesia'),

    # it: italian
    Locale.new(locale: 'italian',  lang_code: :it, canonical: 'italiano'),
    Locale.new(locale: 'italiano', lang_code: :it, canonical: 'italiano'),

    # ja: japanese
    Locale.new(locale: 'japanese', lang_code: :ja, canonical: 'nihongo'),
    Locale.new(locale: 'nihongo',  lang_code: :ja, canonical: 'nihongo'),
    Locale.new(locale: '日本語', lang_code: :ja, canonical: 'nihongo'),

    # ko: korean
    Locale.new(locale: 'korean',   lang_code: :ko, canonical: 'hangugeo'),
    Locale.new(locale: 'hangugeo', lang_code: :ko, canonical: 'hangugeo'),
    Locale.new(locale: '한국어', lang_code: :ko, canonical: 'hangugeo'),

    # ku: kurdish
    Locale.new(locale: 'kurdish', lang_code: :ku, canonical: 'kurmanci'),
    Locale.new(locale: 'kurmancî', lang_code: :ku, canonical: 'kurmanci'),
    Locale.new(locale: 'kurmanci', lang_code: :ku, canonical: 'kurmanci'),

    # nl: dutch
    Locale.new(locale: 'dutch',      lang_code: :nl, canonical: 'nederlands'),
    Locale.new(locale: 'nederlands', lang_code: :nl, canonical: 'nederlands'),

    # no: dutch
    Locale.new(locale: 'norwegian', lang_code: :no, canonical: 'norsk'),
    Locale.new(locale: 'norsk',     lang_code: :no, canonical: 'norsk'),

    # pl: polish
    Locale.new(locale: 'polski', lang_code: :pl, canonical: 'polski'),
    Locale.new(locale: 'polish', lang_code: :pl, canonical: 'polski'),

    # pt: portuguese
    Locale.new(locale: 'portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugués',  lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugues',  lang_code: :pt, canonical: 'portugues-brasileiro'),

    # pt-br: portuguese, brazilian
    Locale.new(locale: 'brazilian portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'brazilian-portuguese', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'português brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'português-brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),
    Locale.new(locale: 'portugues-brasileiro', lang_code: :pt, canonical: 'portugues-brasileiro'),

    # ro: romana
    Locale.new(locale: 'română',   lang_code: :ro, canonical: 'romana'),
    Locale.new(locale: 'romanian', lang_code: :ro, canonical: 'romana'),
    Locale.new(locale: 'romana',   lang_code: :ro, canonical: 'romana'),

    # ru: russian
    Locale.new(locale: 'русский', lang_code: :ru, canonical: 'russkii'),
    Locale.new(locale: 'russian', lang_code: :ru, canonical: 'russkii'),
    Locale.new(locale: 'russkii', lang_code: :ru, canonical: 'russkii'),

    # tl: tagalog
    Locale.new(locale: 'ᜏᜒᜃᜅ᜔ ᜆᜄᜎᜓᜄ᜔', lang_code: :tl, canonical: 'tagalog'),
    Locale.new(locale: 'tagalog', lang_code: :tl, canonical: 'tagalog'),

    # vi: vietnamese
    Locale.new(locale: 'vietnamese', lang_code: :vi, canonical: 'tieng-viet'),
    Locale.new(locale: 'tiếng việt', lang_code: :vi, canonical: 'tieng-viet'),
    Locale.new(locale: 'tieng viet', lang_code: :vi, canonical: 'tieng-viet'),

    # sh: serbo-croatian
    Locale.new(locale: 'serbo-croatian',  lang_code: :sh, canonical: 'srpskohrvatski'),
    Locale.new(locale: 'srpskohrvatski',  lang_code: :sh, canonical: 'srpskohrvatski'),

    # sk: slovakian
    Locale.new(locale: 'slovakian', lang_code: :sk, canonical: 'slovak'),
    Locale.new(locale: 'slovak', lang_code: :sk, canonical: 'slovak'),

    # sl: slovenian
    Locale.new(locale: 'slovenian',   lang_code: :sl, canonical: 'slovenscina'),
    Locale.new(locale: 'slovenščina', lang_code: :sl, canonical: 'slovenscina'),
    Locale.new(locale: 'slovenscina', lang_code: :sl, canonical: 'slovenscina'),

    # sv: swedish
    Locale.new(locale: 'swedish', lang_code: :sv, canonical: 'svenska'),
    Locale.new(locale: 'svenska', lang_code: :sv, canonical: 'svenska'),

    # th: thai
    Locale.new(locale: 'thai',         lang_code: :th, canonical: 'phaasaaaithy'),
    Locale.new(locale: 'phaasaaaithy', lang_code: :th, canonical: 'phaasaaaithy'),
    Locale.new(locale: 'ภาษาไทย',      lang_code: :th, canonical: 'phaasaaaithy'),

    # tr: turkish
    Locale.new(locale: 'turkish', lang_code: :tr, canonical: 'turkce'),
    Locale.new(locale: 'türkçe',  lang_code: :tr, canonical: 'turkce'),
    Locale.new(locale: 'turkce',  lang_code: :tr, canonical: 'turkce'),

    # uk: ukranian
    Locale.new(locale: 'ukrainian',       lang_code: :uk, canonical: 'ukrayinska-mova'),
    Locale.new(locale: 'ukrayinska-mova', lang_code: :uk, canonical: 'ukrayinska-mova'),
    Locale.new(locale: 'українська мова', lang_code: :uk, canonical: 'ukrayinska-mova'),

    # zh: chinese (mandarin)
    Locale.new(locale: 'chinese',   lang_code: :zh, canonical: 'zhong-wen'),
    Locale.new(locale: 'zhong-wen', lang_code: :zh, canonical: 'zhong-wen'),
    Locale.new(locale: '中文', lang_code: :zh, canonical: 'zhong-wen')
  ].freeze

  class << self
    def canonical locale:, lang_code: nil
      return LOCALES.find { |locale_instance| locale_instance.locale == locale } if lang_code.blank?

      @indexed_locales[lang_code] || raise_locale_error(locale)
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
