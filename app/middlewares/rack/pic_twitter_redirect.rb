module Rack
  class PicTwitterRedirect
    def initialize app
      @app = app
    end

    def call env
      request = Rack::Request.new(env)

      if request.path.match?(/twitter/)
        location = request.path.split('pic.twitter.com').first

        encoding_options = {
          invalid:           :replace, # Replace invalid byte sequences
          undef:             :replace, # Replace anything not defined in ASCII
          replace:           '', # Use a blank for those replacements
          universal_newline: true # Always break lines with \n
        }

        ascii_location = location.encode(Encoding.find('ASCII'), encoding_options)
        location       = ascii_location.split('%').first

        return redirect(location)
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
  end
end
