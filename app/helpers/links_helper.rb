module LinksHelper
  # For 2020 theme
  def social_links_by_domain
    {
      'Twitter'   => 'https://twitter.com/crimethinc',
      'Facebook'  => 'https://www.facebook.com/To-Change-Everything-103734818122357',
      'Instagram' => 'https://instagram.com/CrimethincDotCom',
      'Github'    => 'https://github.com/crimethinc',
      'Tumblr'    => 'https://crimethinc.tumblr.com',
      'Mastodon'  => 'https://mastodon.online/@crimethinc',
      'RSS feed'  => 'https://crimethinc.com/feed'
    }
  end

  # For 2017 theme
  def social_links
    {
      'CrimethInc. on Twitter'           => 'https://twitter.com/crimethinc',
      'CrimethincDotCom on Facebook'     => 'https://www.facebook.com/To-Change-Everything-103734818122357',
      'CrimethincDotCom on Instagram'    => 'https://instagram.com/CrimethincDotCom',
      'CrimethInc on Github'             => 'https://github.com/crimethinc',
      'CrimethInc on Tumblr'             => 'https://crimethinc.tumblr.com',
      'CrimethInc on Mastodon'           => 'https://mastodon.online/@crimethinc',
      'CrimethInc.com Articles RSS feed' => 'https://crimethinc.com/feed'
    }
  end

  # For 2017 theme
  def social_link_classes url:, name:
    domain = URI.parse(url).host.downcase.split('.')[-2]
    domain = "link-domain-#{domain}"

    name = name.downcase.to_slug
    name = "link-name-#{name}"

    [name, domain].join(' ')
  end
end
