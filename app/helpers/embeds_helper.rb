module EmbedsHelper
  def embed_twitter(url)
    begin
      oembed_url = open("https://publish.twitter.com/oembed?url=#{url}")
    rescue OpenURI::HTTPError => e
      return "#{embed_link(url)} (deleted)".html_safe
    end

    oembed_json = oembed_url.read
    JSON.parse(oembed_json)["html"].html_safe
  end

  def embed_link(url, id: nil)
    link_to(url.to_s.sub(/^https*:\/\//, "").sub(/\/$/, ""), url.to_s, id: id).html_safe
  end
end
