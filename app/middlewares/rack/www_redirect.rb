module Rack
  class BlogRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.host.start_with?("www.")
        location = request.path.sub("www.", "")
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
