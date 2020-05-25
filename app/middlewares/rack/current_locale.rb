module Rack
  class CurrentLocale
    def initialize app
      @app = app
    end

    def call env
      @req = Rack::Request.new(env)

      set_current_locale
      set_current_locale_from_subdomain
      redirect_to_locale_subdomain

      @app.call(env)
    end

    private

    def set_current_locale
      Current.locale = ::Locale.find_by abbreviation: I18n.locale
    end

    def set_current_locale_from_subdomain
      return if subdomain.blank?
      return unless I18n.available_locales.include? subdomain.to_sym

      Current.locale = ::Locale.find_by abbreviation: subdomain
    end

    def redirect_to_locale_subdomain
      # Force the subdomain to match the locale.
      # Don’t do this in development, because typically local development
      # environments don’t support subdomains (en.localhost doesn’t resolve).

      # Don’t redirect to en.crimethinc.com
      return if Current.locale.english?

      # Don’t redirect if there’s a subdomain
      return if subdomain.present?

      # Don’t redirect in development
      return if Rails.env.production?

      redirect localized_url
    end

    def subdomain
      fully_qualified_domain = @req.host
      locale_subdomain = fully_qualified_domain.split('.').first

      locale_subdomain unless locale_subdomain == fully_qualified_domain
    end

    def decorated_subdomain
      "#{subdomain}." unless subdomain.blank?
    end

    def decorated_port
      ":#{@req.port}" if Rails.env.development?
    end

    def decorated_query_params
      "?#{@req.query_string}" if @req.query_string.present?
    end

    def localized_url
      [
        @req.scheme,
        '://',
        decorated_subdomain,
        @req.host,
        decorated_port,
        @req.path,
        decorated_query_params
      ].join
    end

    def redirect location
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end
  end
end
