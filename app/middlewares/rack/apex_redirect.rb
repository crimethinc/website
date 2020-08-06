module Rack
  class ApexRedirect
    def initialize app
      @app = app
    end

    def call env
      request = Rack::Request.new env

      if request.host.start_with? 'www.'
        domain = request.host.sub('www.', '')
        # location = "#{request.scheme}://#{domain}#{request.path}"
        protocol_separator = '://'
        location = [request.scheme, protocol_separator, domain, request.path].join
        # location = request.scheme + '://' + domain + request.path
        return redirect location
      end

      @app.call env
    end

    private

    def redirect location
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end
  end
end
