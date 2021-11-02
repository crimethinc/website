module LocalizationHelper
  def url_for_current_path_with_subdomain subdomain: :en
    subdomain = subdomain == I18n.default_locale ? nil : "#{subdomain}."
    port      = ":#{request.port}" if request.port.present?

    uri_with_subdomain = [request.protocol, subdomain, request.domain, port, request.path].join

    # the encode/decode stuff is to get international, unicode URIs to be url-encoded
    Addressable::URI.parse(uri_with_subdomain).display_uri.to_s
  end
end
