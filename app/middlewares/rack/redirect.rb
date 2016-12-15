require 'fileutils'

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

      filepath = ::File.expand_path("../redirects.txt", __FILE__)

      if ::File.exist?(filepath)
        ::File.open(filepath).each do |line|
          source_path, target_path = line.chomp.split

          unless source_path =~ /^\//
            source_path = "/#{source_path}"
          end

          unless target_path =~ /^\//
            target_path = "/#{target_path}"
          end

          redirects[source_path] = target_path
        end
      end

      req = Rack::Request.new(env)
      return redirect(redirects[req.path]) if redirects.include?(req.path)
      @app.call(env)
    end
  end
end
