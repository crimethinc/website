module Rack
  class CleanPath
    # delete from source path:
    SUBSTITUTIONS = {
      '/blog'                => '',
      'index.html'           => '',
      '.html'                => '',
      'index.php'            => '',
      '.php'                 => '',
      'comment-page-1'       => '',
      'texts/atoz'           => 'texts',
      'texts/days'           => 'texts',
      'texts/ex'             => 'texts',
      'texts/fx'             => 'texts',
      'texts/harbinger'      => 'texts',
      'texts/images'         => 'texts',
      'texts/insidefront'    => 'texts',
      'texts/mostrecent'     => 'texts',
      'texts/pastfeatures'   => 'texts',
      'texts/r/'             => 'texts/',
      'texts/recentfeatures' => 'texts',
      'texts/rollingthunder' => 'texts',
      'texts/selected'       => 'texts',
      'texts/ux'             => 'texts',
      '%E2%80%A6'            => '', # Unicode elipsis of a truncated URL /atoz/fuc…
      '%E2%80%99'            => '', # URLs from Wordpress sometimes encode ‘,’,“,” like this
      '%E2%80%9C'            => '', # URLs from Wordpress sometimes encode ‘,’,“,” like this
      '%E2%80%9D'            => '', # URLs from Wordpress sometimes encode ‘,’,“,” like this
      '%E2%80%98'            => '', # URLs from Wordpress sometimes encode ‘,’,“,” like this
      %r{/+\z}               => ''
    }.freeze

    # URL_TWEET_TEXT_UNICODE_SEPARATOR = '%E2%80%8E'.freeze
    SMOOSHED_TWEET_TEXT_UNICODE_SEPARATORS = %w[
      %E2%80%8E
      %EF%BF%BD
    ].freeze

    def initialize app
      @app = app
    end

    def call env
      # request
      req = Rack::Request.new(env)

      # source path
      path = req.path

      # get path before Unicode character got smooshed into it
      # /airportblockades�The airport…
      path = unsmoosh_path_from_unicode_tweet_text path

      # make subsitutions, from uncleaned to cleaned
      SUBSTITUTIONS.each do |uncleaned_path, cleaned_path|
        path = path.gsub(uncleaned_path, cleaned_path)
      end

      # convert Unicode to ASCII using transliteration
      # Eg: /ameaça => /ameaca
      path = transliterate_unicode_to_ascii_in path

      # redirect to new cleaned path, but
      # don’t redirect the homepage to nowhere
      if req.path != path && path != ''
        args = "?#{req.query_string}" if req.query_string.present?
        return redirect(path + args.to_s)
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

    def unsmoosh_path_from_unicode_tweet_text path
      SMOOSHED_TWEET_TEXT_UNICODE_SEPARATORS.each do |separator|
        if path.match?(separator)
          path = path.split(separator).first
          break
        end
      end

      path
    end

    def path_pieces path
      path.split('/')
    end

    def file_pieces path_piece
      path_piece.split('.')
    end

    def transliterate_unicode_to_ascii_in path
      return path if path.start_with?('/tce')

      result = path_pieces(path).map do |path_piece|
        file_pieces(path_piece).map { |f| transliterate_unicode_to_ascii(f) }.join('.')
      end

      result.join('/')
    end

    def transliterate_unicode_to_ascii str
      CGI.unescape(str).to_slug
    end
  end
end
