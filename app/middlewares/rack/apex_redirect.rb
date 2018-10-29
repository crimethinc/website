module Rack
  class ApexRedirect
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      if request.host.start_with?('www.')
        location = request.scheme + '://' + request.host.sub('www.', '') + request.path
        return redirect(location)
      end

      if request.host.start_with?('en.')
        location = request.scheme + '://' + request.host.sub('en.', '') + request.path
        return redirect(location)
      end

      @app.call(env)
    end

    private

    def redirect(location)
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end
  end
end
