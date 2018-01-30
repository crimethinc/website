module Rack
  class DomainRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.host.downcase =~ /cwc/ || request.host.downcase =~ /herokuapp/
        location = "https://crimethinc.com" + request.path
        return redirect(location)
      end

      @app.call(env)
    end

    private

    def redirect(location)
      [
        301,
        { "Location" => location, "Content-Type" => "text/html" },
        ["Moved Permanently"]
      ]
    end
  end
end
