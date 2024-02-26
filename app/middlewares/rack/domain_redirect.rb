module Rack
  class DomainRedirect
    # subdomain (optional), path prefix (optional), URL regex to match (required)
    REDIRECT_CONFIGS = [
      [
        '',
        '/steal-something-from-work-day',
        /stealfromwork.crimethinc.com|stealfromworkday.com|stealsomethingfromworkday.com$/
      ],

      ['', '/tce', /tochangeeverything.com/],

      ['',    '', /crimethinc.herokuapp.com$/],
      ['es.', '', /crimethinc.es/],
      ['de.', '', /crimethinc.de/],
      ['cs.', '', /cz.crimethinc.com/], # Fix our orignal mistaken assumption

      ['ar.', '', /ar.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['cs.', '', /cs.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['cz.', '', /cz.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['da.', '', /da.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['de.', '', /de.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['en.', '', /en.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['es.', '', /es.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['fi.', '', /fi.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['fr.', '', /fr.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['gr.', '', /gr.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['he.', '', /he.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['id.', '', /id.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['in.', '', /in.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['it.', '', /it.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['pl.', '', /pl.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['pt.', '', /pt.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['ru.', '', /ru.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['sv.', '', /sv.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['tr.', '', /tr.cwc.im$/], # TEMP: work out better general purpose locale subdomain + short domain redirect
      ['',    '', /cwc.im/]
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
