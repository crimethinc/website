# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://crimethinc.com'
SitemapGenerator::Sitemap.compress     = false

SitemapGenerator::Sitemap.create do
  # # 'RSS' feeds discovery page, for all languages with articles
  # add '/feeds'
  #
  # # default articles feed, for english articles
  # add '/feed'
  #
  # add_to_index '/feed/',         changefreq: 'daily',  lastmod: Time.now.utc
  # add_to_index '/podcast/feed/', changefreq: 'weekly', lastmod: Time.now.utc
  #
  # Category.find_each do |category|
  #   add_to_index "/categories/#{category.slug}/feed/"
  # end

  # # TODO: audit this
  # # TODO: add /languages pages
  # # TODO: add locale /subdomains?
  # static_paths = [
  #   '/about/',
  #   '/arts/submission-guidelines',
  #   '/books/into-libraries/',
  #   '/books/lit-kit/',
  #   '/categories/',
  #   '/faq/',
  #   'games/j20',
  #   '/get/',
  #   '/kickstarter/2017/',
  #   '/listen/',
  #   '/library/',
  #   '/read/',
  #   '/rt/',
  #   '/rt/archives/',
  #   '/start/',
  #   '/steal-something-from-work-day',
  #   '/store/',
  #   '/store/audio/',
  #   '/store/added/',
  #   '/tce/',
  #   '/tools/',
  #   '/watch/'
  # ]

  # TODO: read this from app data
  tce_languages = %w[
    czech
    deutsch
    espanol
    espanol-america-latina
    polski
    portugues
    quebecois
    slovenscina
    slovensko
    فارسی
    日本語
    한국어
    lietuvos
    portugues
    ภาษาไทย
  ]

  tce_languages.each do |lang|
    static_paths.push("/tce/#{lang}/", "/tce/#{lang}/get/")
  end

  # static_paths.each do |path|
  #   add path, changefreq: 'monthly', lastmod: '2017-01-01'
  # end

  # Article.live.published.find_each do |page|
  #   add page.path, lastmod: page.updated_at
  # end

  # Category.find_each do |category|
  #   add "/categories/#{category.slug}/"
  # end

  # [1996..Time.zone.today.year].to_a.each do |year|
  #   add "/#{year}/"
  # end

  # [Book, Episode, Page, Podcast, Video, Zine, Journal, Issue, Episode, Poster, Sticker, Logo].each do |model|
  #   model.find_each do |page|
  #     add page.path, lastmod: page.updated_at
  #   end
  # end
end
