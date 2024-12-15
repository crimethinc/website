module SitemapHelper
  def sitemap_urlset_tag_attributes
    {
      'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
      'xmlns'              => 'http://www.sitemaps.org/schemas/sitemap/0.9',
      'xmlns:image'        => 'http://www.google.com/schemas/sitemap-image/1.1',
      'xmlns:video'        => 'http://www.google.com/schemas/sitemap-video/1.1',
      'xmlns:news'         => 'http://www.google.com/schemas/sitemap-news/0.9',
      'xmlns:mobile'       => 'http://www.google.com/schemas/sitemap-mobile/1.0',
      'xmlns:pagemap'      => 'http://www.google.com/schemas/sitemap-pagemap/1.0',
      'xmlns:xhtml'        => 'http://www.w3.org/1999/xhtml',
      'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'
    }
  end

  def sitemap_url_tag loc, lastmod: Time.current, changefreq: :weekly, priority: 0.5
    content = [
      tag.loc(loc),
      tag.lastmod(lastmod.iso8601),
      tag.changefreq(changefreq),
      tag.priority(priority)
    ].join.html_safe # rubocop:disable Rails/OutputSafety

    tag.url content
  end
end