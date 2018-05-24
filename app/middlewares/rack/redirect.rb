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
          unless line.blank?
            source_path, target_path = line.chomp.split

            unless source_path =~ /^\/|http/
              source_path = "/#{source_path}"
            end

            unless target_path =~ /^\/|http/
              target_path = "/#{target_path}"
            end

            redirects[source_path] = target_path
          end
        end
      end

      req = Rack::Request.new(env)

      if redirects.include?(req.path)
        if req.query_string.present?
          args = "?#{req.query_string}"
        end

        return redirect(redirects[req.path] + args.to_s)
      end

      @app.call(env)
    end
  end
end
