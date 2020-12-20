module LinksHelper
  SOCIAL_LINKS = {
    'CrimethInc. on Twitter'           => 'https://twitter.com/crimethinc',
    'Crimethinc. on Facebook'          => 'https://www.facebook.com/To-Change-Everything-103734818122357',
    'Crimethinc. on Instagram'         => 'https://instagram.com/CrimethincAgain',
    'CrimethInc. on Github'            => 'https://github.com/crimethinc',
    'CrimethInc. on Tumblr'            => 'https://crimethinc.tumblr.com',
    'CrimethInc. on Mastodon'          => 'https://mastodon.online/@crimethinc',
    'CrimethInc.com Articles RSS feed' => 'https://crimethinc.com/feed'
  }.freeze

  def social_links
    SOCIAL_LINKS
  end

  def social_link_classes url:, name:
    domain = URI.parse(url).host.downcase.split('.')[-2]
    domain = "link-domain-#{domain}"

    name = name.downcase.to_slug
    name = "link-name-#{name}"

    [name, domain].join(' ')
  end
end
