module LinksHelper
  def social_link_classes(link)
    url    = URI.parse(link.url)
    domain = url.host.downcase.split(".")[-2]
    domain = "link-domain-#{domain}"

    name   = link.name.downcase.to_slug
    name   = "link-name-#{name}"
    [name, domain].join(" ")
  end
end
