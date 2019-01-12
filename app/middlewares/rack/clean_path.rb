module Rack
  class CleanPath
    # delete from source path:
    SUBSITUTIONS = {
      '/blog'                => '',
      'index.html'           => '',
      '.html'                => '',
      'index.php'            => '',
      '.php'                 => '',
      'texts/atoz'           => 'texts',
      'texts/days'           => 'texts',
      'texts/ex'             => 'texts',
      'texts/fx'             => 'texts',
      'texts/harbinger'      => 'texts',
      'texts/images'         => 'texts',
      'texts/insidefront'    => 'texts',
      'texts/mostrecent'     => 'texts',
      'texts/pastfeatures'   => 'texts',
      'texts/r'              => 'texts',
      'texts/recentfeatures' => 'texts',
      'texts/rollingthunder' => 'texts',
      'texts/selected'       => 'texts',
      'texts/ux'             => 'texts',
      %r{/+\z}               => ''
    }.freeze

    def initialize app
      @app = app
    end

    def call env
      # request
      req = Rack::Request.new(env)

      # source path
      path = req.path

      # make subsitutions, from uncleaned to cleaned
      SUBSITUTIONS.each do |uncleaned_path, cleaned_path|
        path = path.sub(uncleaned_path, cleaned_path)
      end

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
  end
end
