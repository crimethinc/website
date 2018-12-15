module LocalizationHelper
  def url_for_current_path_with_subdomain subdomain: :en
    subdomain = subdomain == I18n.default_locale ? nil : "#{subdomain}."
    port      = ":#{request.port}" if request.port.present?

    [request.protocol, subdomain, request.domain, port, request.path].join
  end
end
