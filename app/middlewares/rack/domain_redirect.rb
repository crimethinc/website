module Rack
  class DomainRedirect
    # subdomain (optional), path prefix (optional), URL regex to match (required)
    main_redirect_configs = [
      # SSfWD
      ['', '/steal-something-from-work-day', /stealfromwork\.crimethinc\.com$/],
      ['', '/steal-something-from-work-day', /stealfromworkday\.com$/],
      ['', '/steal-something-from-work-day', /stealsomethingfromworkday\.com$/],

      # TCE
      ['', '/tce', /tochangeeverything\.com/],

      # Heroku subdomain
      ['', '', /\.herokuapp\.com$/],

      # Other TLDs
      ['', '', /crimethinc\.gay$/],

      # ccTLDs => localized subdomain
      ['es.', '', /crimethinc\.es/],
      ['de.', '', /crimethinc\.de/],
      ['cs.', '', /cz\.crimethinc\.com/] # Fix our orignal mistaken assumption
    ]

    cc_tld_subdomains = %w[
      ar
      be bg bn
      cs cz
      da de dv
      en es eu
      fa fi fr
      gl gr
      he hu
      id in it
      ja
      ko ku
      nl no
      pl pt
      ro ru
      sk sl sv
      th tl tr
      uk
      vi
      zh
    ]

    # de.cwc.im, es.cwc.im, etc
    # TEMP: work out better general purpose for (locale subdomain + short domain) redirect
    cc_tld_short_domain_redirect_configs = cc_tld_subdomains.map do |subdomain|
      ["#{subdomain}.", '', /#{subdomain}\.cwc\.im$/]
    end

    # the root short domain (cwc.im) MUST be AFTER ccTLD short domains (de.cwc.im, etc)
    # short domain (for historical twitter/etc posts)
    root_short_domain_redirect_config = [
      ['', '', /cwc\.im/]
    ]

    # combined redirect configs
    REDIRECT_CONFIGS = (
      main_redirect_configs +
      cc_tld_short_domain_redirect_configs +
      root_short_domain_redirect_config
    ).freeze

    PROTOCOL = 'https://'.freeze
    DOMAIN   = 'crimethinc.com'.freeze

    def initialize app
      @app = app
    end

    def call env
      request = Rack::Request.new env

      REDIRECT_CONFIGS.each do |config|
        subdomain   = config[0]
        path_prefix = config[1]
        url_regex   = config[2]
        path        = path_prefix + request.path

        if url_regex.match? request.host.downcase
          location = redirect_location subdomain: subdomain, path: path
          return redirect location
        end
      end

      @app.call env
    end

    private

    def redirect_location path: '', subdomain: ''
      [PROTOCOL, subdomain, DOMAIN, path].join
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
