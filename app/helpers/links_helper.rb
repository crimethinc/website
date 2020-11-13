module LinksHelper
  SOCIAL_LINKS = {
    'CrimethInc. on Twitter'           => 'https://twitter.com/crimethinc',
    'Crimethinc. on Facebook'          => 'https://www.facebook.com/To-Change-Everything-103734818122357',
    'Crimethinc. on Instagram'         => 'https://instagram.com/CrimethincAgain',
    'CrimethInc. on Github'            => 'https://github.com/crimethinc',
    'CrimethInc. on Tumblr'            => 'https://crimethinc.tumblr.com',
    'CrimethInc. on Mastodon'          => 'https://todon.eu/@CrimethInc',
    'CrimethInc. on Telegram'          => 'https://t.me/ExWorkers',
    'CrimethInc.com Articles RSS feed' => 'https://crimethinc.com/feed'
  }.freeze

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
    SOCIAL_LINKS
  end

  # For 2017 theme
  def social_link_classes url:, name:
    # Telegram is a special case because its domain is just t.me, not telegram.[anything]
    domain = case URI.parse(url).host.downcase
             when 't.me'
               'telegram'
             else
               URI.parse(url).host.downcase.split('.')[-2]
             end
    domain_class = "link-domain-#{domain}"

    name = name.downcase.to_slug
    name_class = "link-name-#{name}"

    [name_class, domain_class].join(' ')
  end
end
