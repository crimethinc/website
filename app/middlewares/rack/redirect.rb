module Rack
  class Redirect
    def initialize(app)
      @app = app
    end

    def redirect(location)
      [
        301,
        { "Location" => location, "Content-Type" => "text/html" },
        ["Moved Permanently"]
      ]
    end

    def call(env)
      redirects = {}

      filepath = ::File.expand_path("redirects.txt", __FILE__)

      if ::File.exist?(filepath)
        ::File.open(filepath).read.each do |line|
          source_path, target_path = line.chomp.split
          redirects[source_path] = target_path
        end
      end

      req = Rack::Request.new(env)
      return redirect(redirects[req.path]) if redirects.include?(req.path)
      @app.call(env)
    end
  end
end
