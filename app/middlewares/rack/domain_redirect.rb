module Rack
  class DomainRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.host.downcase =~ /cwc/
        return redirect_to_crimethinc request
      end

      if request.host.downcase =~ /crimethinc.herokuapp.com$/
        return redirect_to_crimethinc request
      end

      @app.call(env)
    end

    private

    def redirect_to_crimethinc request
      location = ['https://crimethinc.com', 'request.path'].join
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
