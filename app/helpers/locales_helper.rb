module LocalesHelper
  def locale abbreviation
    Locale.find_by(abbreviation: abbreviation.downcase)
  end

  def locale_nav_item_classes_for locale
    classes = []
    classes << locale.abbreviation
    classes << 'current' if I18n.locale.to_s == locale.abbreviation
    classes
  end
end
