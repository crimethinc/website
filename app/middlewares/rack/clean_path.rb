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
      '%E2%80%8E'            => '', # Smooshed into the URL by some Twitter app
      %r{/+\z}               => ''
    }.freeze

    SMOOSHED_TWEET_TEXT_UNICODE_SEPARATORS = %w[
      %E2%80%8E
      %EF%BF%BD
    ].freeze

    def initialize app
      @app = app
    end

    def call env
      # request
      @req = Rack::Request.new(env)

      # source path
      @path = @req.path

      # no-op for root route and assets
      return @app.call(env) if exit_early?

      unsmoosh_path_from_unicode_tweet_text!
      make_subsitutions!
      transliterate_unicode_to_ascii!
      add_query_params!
      fallback_to_default!

      # redirect to new cleaned path
      return redirect(@path) unless @req.fullpath == @path

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

    def exit_early?
      @req.path == '/' || @req.path.starts_with?('/assets')
    end

    # get path before Unicode character got smooshed into it
    # /airportblockades�The airport…
    def unsmoosh_path_from_unicode_tweet_text!
      SMOOSHED_TWEET_TEXT_UNICODE_SEPARATORS.each do |separator|
        if @path.match?(separator)
          @path = @path.split(separator).first
          break
        end
      end
    end

    # make subsitutions, from uncleaned to cleaned
    def make_subsitutions!
      SUBSTITUTIONS.each do |uncleaned_path, cleaned_path|
        @path = @path.gsub(uncleaned_path, cleaned_path)
      end
    end

    def path_pieces
      @path.to_s.split('/')
    end

    def file_pieces path_piece
      path_piece.split('.')
    end

    # convert Unicode to ASCII using transliteration
    # Eg: /ameaça => /ameaca
    def transliterate_unicode_to_ascii!
      return @path if @path.start_with?('/tce')

      result = path_pieces.map do |path_piece|
        file_pieces(path_piece).map { |fp| transliterate_unicode_to_ascii(fp) }.join('.')
      end

      result.join('/')
    end

    def transliterate_unicode_to_ascii str
      CGI.unescape(str).to_slug
    end

    # add original query params back to cleaned
    def add_query_params!
      args = "?#{@req.query_string}" if @req.query_string.present?
      @path += args.to_s
    end

    # don’t redirect the homepage to nowhere
    def fallback_to_default!
      @path = @path.blank? ? '/' : @path
    end
  end
end
