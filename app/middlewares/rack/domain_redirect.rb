module Rack
  class DomainRedirect
    # subdomain (optional), path prefix (optional), URL regex to match (required)
    MAIN_REDIRECT_CONFIGS = [
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
      ['cs.', '', /cz\.crimethinc\.com/], # Fix our orignal mistaken assumption

      # short domain (for historical twitter/etc posts)
      ['', '', /cwc\.im/]
    ].freeze

    CC_TLD_SUBDOMAINS = %w[
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
    ].freeze

    # TEMP: work out better general purpose locale subdomain + short domain redirect
    CC_TLD_SHORT_DOMAIN_REDIRECT_CONFIGS = CC_TLD_SUBDOMAINS.map do |subdomain|
      ["#{subdomain}.", '', /#{subdomain}\.cwc\.im$/]
    end.freeze

    # combined redirect configs
    REDIRECT_CONFIGS = (MAIN_REDIRECT_CONFIGS + CC_TLD_SHORT_DOMAIN_REDIRECT_CONFIGS).freeze

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
