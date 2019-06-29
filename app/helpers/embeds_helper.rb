module EmbedsHelper
  def embed_link url, id: nil
    link_to(url.to_s.sub(%r{^https*:\/\/}, '').sub(%r{/$}, ''), url.to_s, id: id).html_safe
  end
end
