require 'set'
# Q: What do we say to the gods of pen testing?
# A: Not today, kid!
#
# For requests that look like their "pen testing" the site,
# send back a 418 HTTP status code, instead of a 404/500 in our error logs
#   https://httpstatuses.com/418
#   https://http.cat/418.jpg

module Rack
  class Teapot
    BANNED_SEGMENTS = Set.new(
      %w[
        ads.txt
        afacacaeusaaa
        asp.net
        error.asp
        kindeditor
        README.txt
        wp
        wp-login
        wp-admin
        cdnbuster
        jars
      ]
    ).freeze

    def initialize app
      @app = app
    end

    def call env
      # request
      req = Rack::Request.new(env)

      # source path
      path_segments = req.path.split('/')

      # query params
      query_params = req.params.to_a.flatten

      segments = [path_segments, query_params].flatten

      # send a 418 code, if it looks like it’s a pen test kind of request
      return i_am_a_teapot if segments.any? { |segment| BANNED_SEGMENTS.member? segment }

      @app.call(env)
    end

    private

    def i_am_a_teapot
      [
        418,
        { 'Content-Type' => 'text/plain' },
        ["\nI'm a teapot\n"]
      ]
    end
  end
end
