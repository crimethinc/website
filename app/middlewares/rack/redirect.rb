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

      # delete from source path: index.html
      path = path.sub('index.html', '')

      # delete from source path: .html extension
      path = path.sub('.html', '')

      # delete from source path: index.php
      path = path.sub('index.php', '')

      # delete from source path: .php extension
      path = path.sub('.php', '')

      # delete from source path: trailing one or many slashes
      path = path.sub(%r{/+\z}, '')

      if redirects.include?(path)
        args = "?#{req.query_string}" if req.query_string.present?

        return redirect(redirects[path] + args.to_s)
      end

      @app.call(env)
    end
  end
end
