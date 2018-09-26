module LinksHelper
  def social_links
    {
      'CrimethInc. on Twitter'        => 'https://twitter.com/crimethinc',
      'CrimethincDotCom on Facebook'  => 'https://facebook.com/CrimethincDotCom',
      'CrimethincDotCom on Instagram' => 'https://instagram.com/CrimethincDotCom',
      'CrimethInc. on Patreon'        => 'https://www.patreon.com/crimethinc',
      'CrimethInc.com RSS feed'       => 'https://crimethinc.com/feed',
      'CrimethInc.com on Github'      => 'https://github.com/crimethinc'
    }
  end

  def social_link_classes url:, name:
    domain = URI.parse(url).host.downcase.split('.')[-2]
    domain = "link-domain-#{domain}"

    name   = name.downcase.to_slug
    name   = "link-name-#{name}"
    [name, domain].join(' ')
  end
end
