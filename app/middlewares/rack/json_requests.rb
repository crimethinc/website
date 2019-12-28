module Rack
  class JsonRequests
    API_REQUEST_ERROR = {
      status: '406',
      title:  'Content Type Not Acceptable',
      detail: 'Y\'all requested JSON, but we don\'t do that'
    }.freeze

    def initialize app
      @app = app
    end

    def call env
      request = Rack::Request.new(env)
      return json_406_error if invalid_api_request? request

      @app.call(env)
    end

    private

    def invalid_api_request? request
      return false if request.path.include?('collection_posts') ||
                      request.path.include?('manifest.json') ||
                      request.path.include?('feed.json')

      http_accept = request.env['HTTP_ACCEPT']
      http_accept&.start_with?('application/json')
    end

    def json_406_error
      [
        406,
        { 'Content-Type' => 'application/json' },
        [{ errors: [API_REQUEST_ERROR] }.to_json]
      ]
    end
  end
end
