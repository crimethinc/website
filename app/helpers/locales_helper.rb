module LocalesHelper
  def locale abbreviation
    Locale.find_by(abbreviation: abbreviation.downcase)
  end
end
