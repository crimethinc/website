module Rack
  class TransliterateUnicode
    def initialize app
      @app = app
    end

    def call env
      # request
      req = Rack::Request.new(env)

      # source path
      path = req.path

      # don’t transliterate for /tce URLs
      return @app.call(env) if path =~ %r{^/tce}

      # convert Unicode to ASCII using transliteration
      # Eg: /ameaça => /ameaca
      path_pieces                = path.split '/'
      transliterated_path_pieces = path_pieces.map { |pp| transliterate pp }
      path                       = transliterated_path_pieces.join '/'

      # redirect to new cleaned path, but
      # don’t redirect the homepage to nowhere
      if req.path != path && path != ''
        args = "?#{req.query_string}" if req.query_string.present?
        return redirect(path + args.to_s)
      end

      @app.call(env)
    end

    private

    def transliterate str
      pieces                = str.split '.'
      transliterated_pieces = pieces.map { |piece| CGI.unescape(piece).to_slug }
      transliterated_pieces.join '.'
    end

    def redirect location
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end
  end
end
