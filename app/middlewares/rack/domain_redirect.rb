module Rack
  class DomainRedirect
    # subdomain (optional), path prefix (optional), URL regex to match (required)
    REDIRECT_CONFIGS = [
      # SSfWD
      ['', '/steal-something-from-work-day', /stealfromwork.crimethinc.com$/],
      ['', '/steal-something-from-work-day', /stealfromworkday.com$/],
      ['', '/steal-something-from-work-day', /stealsomethingfromworkday.com$/],

      # TCE
      ['', '/tce', /tochangeeverything.com/],

      # Heroku subdomain
      ['', '', /crimethinc.herokuapp.com$/],

      # Other TLDs
      ['', '', /crimethinc.gay$/],

      # ccTLDs => localized subdomain
      ['es.', '', /crimethinc.es/],
      ['de.', '', /crimethinc.de/],
      ['cs.', '', /cz.crimethinc.com/], # Fix our orignal mistaken assumption

      # short domain (for historical twitter/etc posts)
      ['', '', /cwc.im/],

      # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['ar.', '', /ar.cwc.im$/],
      ['cs.', '', /cs.cwc.im$/],
      ['cz.', '', /cz.cwc.im$/],
      ['da.', '', /da.cwc.im$/],
      ['de.', '', /de.cwc.im$/],
      ['en.', '', /en.cwc.im$/],
      ['es.', '', /es.cwc.im$/],
      ['fi.', '', /fi.cwc.im$/],
      ['fr.', '', /fr.cwc.im$/],
      ['gr.', '', /gr.cwc.im$/],
      ['he.', '', /he.cwc.im$/],
      ['id.', '', /id.cwc.im$/],
      ['in.', '', /in.cwc.im$/],
      ['it.', '', /it.cwc.im$/],
      ['pl.', '', /pl.cwc.im$/],
      ['pt.', '', /pt.cwc.im$/],
      ['ru.', '', /ru.cwc.im$/],
      ['sv.', '', /sv.cwc.im$/],
      ['tr.', '', /tr.cwc.im$/]
    ].freeze

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
