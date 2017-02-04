# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://crimethinc.com"

SitemapGenerator::Sitemap.create do
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

  add_to_index '/feed'
  add_to_index '/podcast/feed'

  static_paths = [
      "/rt/", "/rt/archives/",
      "/store/", "/store/audio/", "/store/added/",
      "/kickstarter/2017/"
  ]

  tce_languages = ["czech", "deutsch", "espanol", "polski", "portugues", "quebecois", "slovenscina", "slovensko"]
  tce_languages.each do |lang|
    static_paths.push("/tce/#{lang}/", "/tce/#{lang}/get/")
  end

  static_paths.each do |path|
    add path, changefreq: "monthly", lastmod: "2016-01-01"
  end

  [Article, Book, Episode, Page, Podcast, Video].each do |model|
    model.find_each do |page|
      add page.path, lastmod: page.updated_at
    end
  end
end
