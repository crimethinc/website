module Rack
  class Redirect
    def initialize(app)
      @app = app
    end

    def redirect(location)
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html' },
        ['Moved Permanently']
      ]
    end

    def call(env)
      redirects = {}

      filepath = ::File.expand_path('../redirects.txt', __FILE__)

      if ::File.exist?(filepath)
        ::File.open(filepath).each do |line|
          next if line.blank?

          source_path, target_path = line.chomp.split

          source_path = "/#{source_path}" unless %r{^/|http}.match?(source_path)
          target_path = "/#{target_path}" unless %r{^/|http}.match?(target_path)

          redirects[source_path] = target_path
        end
      end

      req = Rack::Request.new(env)

      # source path
      path = req.path

      # delete from source path:
      #   index.html
      #   .html extension
      #   index.php
      #   .php extension
      #   trailing one or many slashes
      removable_patterns = [
        'index.html',
        '.html',
        'index.php',
        '.php',
        %r{/+\z}
      ]

      removable_patterns.each do |removable_pattern|
        path = path.sub(removable_pattern, '')
      end

      # normalize source paths: all /texts/*/… => /texts/…
      %w[atoz days ex fx harbinger images insidefront mostrecent
         pastfeatures r recentfeatures rollingthunder selected ux].each do |section|
        path = path.sub("/texts/#{section}", '/texts')
      end

      if redirects.include?(path)
        args = "?#{req.query_string}" if req.query_string.present?

        return redirect(redirects[path] + args.to_s)
      end

      @app.call(env)
    end
  end
end
