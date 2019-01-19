module Rack
  class Redirect
    def initialize app
      @app = app
    end

    def call env
      req = Rack::Request.new(env)

      # source path
      path = req.path

      # special case: non-ASCII paths
      redirects = {
        '/search?utf8=✓&' => '/search',
        '/tce/%uFEFF'     => '/tce'
      }

      return redirect(redirects[path]) if redirects.include?(path)

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
  end
end
