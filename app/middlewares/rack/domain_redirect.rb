module Rack
  class DomainRedirect
    def initialize app
      @app = app
    end

    def call env
      request = Rack::Request.new(env)
      host    = request.host.downcase
      path    = request.path

      return redirect_to_tce path if /tochangeeverything.com$/.match?(host)

      {
        ''   => /cwc|crimethinc.herokuapp.com$/,
        'es' => /crimethinc.es/,
        'de' => /crimethinc.de/
      }.each do |subdomain, localized_tld|
        return redirect_to_crimethinc(path, subdomain: subdomain) if localized_tld.match?(host)
      end

      @app.call env
    end

    private

    def redirect_to_crimethinc path, subdomain: ''
      subdomain += '.' unless subdomain == ''

      location = ['https://', subdomain, 'crimethinc.com', path].join
      redirect location
    end

    def redirect_to_tce path
      location = ['https://crimethinc.com/tce', path].join
      redirect location
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
