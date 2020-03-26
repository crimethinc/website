class Locales
  class << self
    def live
      locales = Locale.all

      locales.each do |locale|
        locale.articles_count = Article.live.published.where(locale: locale.abbreviation).count
      end

      locales
        .reject { |locale| locale.articles_count.zero? }
        .sort_by(&:articles_count)
        .reverse
    end
  end
end
