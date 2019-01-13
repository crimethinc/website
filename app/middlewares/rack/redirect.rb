require_relative 'redirect_pairs'

module Rack
  class Redirect
    def initialize app
      @app = app
    end

    def call env
      req = Rack::Request.new(env)

      # source path
      path = req.path

      if redirects.include?(path)
        args = "?#{req.query_string}" if req.query_string.present?
        return redirect(redirects[path] + args.to_s)
      end

      @app.call(env)
    end

    private

    def redirect location
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end

    def redirects
      @redirects ||= REDIRECT_PAIRS
    end
  end
end
