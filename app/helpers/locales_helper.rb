module LocalesHelper
  def locale_subdomain_url locale
    abbreviation = if locale.is_a? Locale
                     locale.abbreviation
                   else
                     locale
                   end

    "https://#{abbreviation}.crimethinc.com"
  end

  def locale abbreviation
    Locale.find_by abbreviation: abbreviation.downcase
  end

  def locale_nav_item_classes_for locale
    classes = []
    classes << locale.abbreviation
    classes << 'current' if I18n.locale.to_s == locale.abbreviation
    classes
  end

  def link_to_locale_name locale
    link_to locale.name, [:language, { locale: locale.name.downcase.tr(' ', '-') }]
  end

  def link_to_locale_slug locale
    link_to locale.slug, [:language, { locale: locale.slug.to_sym }]
  end

  def link_to_locale_english_name locale
    link_to locale.name_in_english, [:language, { locale: locale.name_in_english.downcase.tr(' ', '-') }]
  end
end
