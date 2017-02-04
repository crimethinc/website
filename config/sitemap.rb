# Set the host name for URL creation
SitemapGenerator::Sitemap.create(default_host: "https://crimethinc.com", compress: true)  do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  # add article_path, :priority => 0.7, :changefreq => 'daily'

  static_paths = [
      "/about/",
      "/arts/submission-guidelines",
      "/books/into-libraries/", "/books/lit-kit/",
      "/categories/",
      "/get/",
      "/kickstarter/2017/",
      "/listen/",
      "/read/",
      "/rt/", "/rt/archives/",
      "/start/",
      "/store/", "/store/audio/", "/store/added/",
      "/tce/",
      "/watch/",
  ]
  tce_languages = ["czech", "deutsch", "espanol", "polski", "portugues", "quebecois", "slovenscina", "slovensko"]

  tce_languages.each do |lang|
    static_paths.push("/tce/#{lang}/", "/tce/#{lang}/get/")
  end

  static_paths.each do |path|
    add path, changefreq: "monthly", lastmod: "2017-01-01"
  end

  add_to_index "/feed/", changefreq: "daily", lastmod: Time.now
  add_to_index "/podcast/feed/", changefreq: "weekly", lastmod: Time.now

  Category.find_each do |category|
    add_to_index "/categories/#{category.slug}/feed/"
  end

  Article.live.published.find_each do |page|
    add page.path, lastmod: page.updated_at
  end

  Category.find_each do |category|
    add "/categories/#{category.slug}/"
  end

  [Book, Episode, Page, Podcast, Video].each do |model|
    model.find_each do |page|
      add page.path, lastmod: page.updated_at
    end
  end
end
