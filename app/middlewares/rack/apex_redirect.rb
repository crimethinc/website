module Rack
  class ApexRedirect
    def initialize app
      @app = app
    end

    def call env
      @request = Rack::Request.new env

      return redirect location if @request.host.start_with? 'www.'

      @app.call env
    end

    private

    def location
      [scheme, separator, domain, path].join
    end

    def scheme
      @request.scheme
    end

    def domain
      @request.host.sub('www.', '')
    end

    def separator
      '://'
    end

    def path
      @request.path
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
