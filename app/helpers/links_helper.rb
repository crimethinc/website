module LinksHelper
  SOCIAL_LINKS = {
    'CrimethInc. on Mastodon'          => 'https://todon.eu/@CrimethInc',
    'Crimethinc. on Facebook'          => 'https://facebook.com/To-Change-Everything-103734818122357',
    'Crimethinc. on Instagram'         => 'https://instagram.com/crimethincredux',
    'Crimethinc. on Bluesky'           => 'https://bsky.app/profile/crimethinc.com',
    'CrimethInc. on Github'            => 'https://github.com/crimethinc',
    'CrimethInc. on Tumblr'            => 'https://crimethinc.tumblr.com',
    'CrimethInc. on Bandcamp'          => 'https://crimethinc.bandcamp.com',
    'CrimethInc. on Telegram'          => 'https://t.me/ExWorkers',
    'Crimethinc. on TikTok'            => 'https://tiktok.com/@crimethinc',
    'CrimethInc. on Peertube'          => 'https://kolektiva.media/a/crimethinc',
    'CrimethInc. on YouTube'           => 'https://youtube.com/@crimethincexworkerscollective',
    'CrimethInc. on Reddit'            => 'https://reddit.com/r/CrimethInc',
    'CrimethInc.com Articles RSS feed' => 'https://crimethinc.com/feed'
  }.freeze

  # For 2025 theme
  def social_links_by_domain
    [
      { Mastodon:   'https://todon.eu/@crimethinc' },
      { Bluesky:    'https://bsky.app/profile/crimethinc.com' },
      { Instagram:  'https://instagram.com/crimethincredux' },
      { 'RSS feed': 'https://crimethinc.com/feed' },
      { Facebook:   'https://facebook.com/To-Change-Everything-103734818122357' },
      { Github:     'https://github.com/crimethinc' },
      { Telegram:   'https://t.me/ExWorkers' },
      { Tumblr:     'https://crimethinc.tumblr.com' },
      { Bandcamp:   'https://crimethinc.bandcamp.com' },
      { TikTok:     'https://tiktok.com/@crimethinc' },
      { Peertube:   'https://kolektiva.media/a/crimethinc' },
      { YouTube:    'https://youtube.com/@crimethincexworkerscollective' },
      { Reddit:     'https://reddit.com/r/CrimethInc' }
    ]
  end

  # For 2017 theme
  def social_links = SOCIAL_LINKS

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
