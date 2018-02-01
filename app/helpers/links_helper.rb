module LinksHelper
  def social_links
    {
      "CrimethInc. on Twitter"        => "https://twitter.com/crimethinc",
      "CrimethincDotCom on Facebook"  => "https://facebook.com/CrimethincDotCom",
      "CrimethincDotCom on Instagram" => "https://instagram.com/CrimethincDotCom",
      "Crimethinc. on Medium"         => "https://medium.com/@crimethinc",
      "CrimethInc. on Tumblr"         => "http://crimethincdotcom.tumblr.com",
      "CrimethInc. on Wordpress"      => "https://crimethincdotcom.wordpress.com",
      "CrimethInc. on Vimeo"          => "https://vimeo.com/crimethinc",
      "CrimethInc. on Youtube"        => "https://www.youtube.com/channel/UCH9VbQUhFVjTyUZhZqDVlDw",
      "Crimethinc. on Periscope"      => "https://www.periscope.tv/crimethinc",
      "CrimethInc. on Snapchat"       => "https://www.snapchat.com/add/crimethinc",
      "CrimethInc. on Patreon"        => "https://www.patreon.com/crimethinc",
      "CrimethInc.com RSS feed"       => "https://crimethinc.com/feed",
      "CrimethInc.com on Github"      => "https://github.com/crimethinc"
    }
  end

  def social_link_classes url:, name:
    domain = URI.parse(url).host.downcase.split(".")[-2]
    domain = "link-domain-#{domain}"

    name   = name.downcase.to_slug
    name   = "link-name-#{name}"
    [name, domain].join(" ")
  end
end
