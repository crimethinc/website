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
      content_type = request.env['HTTP_ACCEPT']
      return json_406_error if content_type.start_with?('application/json')

      @app.call(env)
    end

    private

    def json_406_error
      [
        406,
        { 'Content-Type' => 'application/json' },
        [{ errors: [API_REQUEST_ERROR] }.to_json]
      ]
    end
  end
end
