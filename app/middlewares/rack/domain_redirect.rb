module Rack
  class DomainRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      return redirect_to_crimethinc request if /cwc/.match?(request.host.downcase)

      return redirect_to_crimethinc request if /crimethinc.herokuapp.com$/.match?(request.host.downcase)

      @app.call(env)
    end

    private

    def redirect_to_crimethinc request
      location = ['https://crimethinc.com', request.path].join
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
