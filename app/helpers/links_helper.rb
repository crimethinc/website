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

  def social_links
    SOCIAL_LINKS
  end

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
