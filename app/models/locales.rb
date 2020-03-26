class Locales
  class << self
    def live
      return @live if @live.present?

      @live = Locale.all

      @live.each do |locale|
        locale.articles_count = Article.live.published.where(locale: locale.abbreviation).count
      end

      @live = @live
              .reject { |locale| locale.articles_count.zero? }
              .sort_by(&:articles_count)
              .reverse
    end
  end
end
