module Rack
  class DomainRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      host    = request.host.downcase

      return redirect_to_crimethinc request if /cwc/.match?(host)
      return redirect_to_crimethinc request if /crimethinc.herokuapp.com$/.match?(host)
      return redirect_to_tce        request if /tochangeeverything.com$/.match?(host)

      @app.call(env)
    end

    private

    def redirect_to_crimethinc request
      location = ['https://crimethinc.com', request.path].join
      redirect location
    end

    def redirect_to_tce request
      location = ['https://crimethinc.com/tce', request.path].join
      redirect location
    end

    def redirect(location)
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end
  end
end
