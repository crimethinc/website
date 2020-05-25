module Rack
  class CurrentTheme
    def initialize app
      @app = app
    end

    def call env
      Current.theme = ENV.fetch('THEME') { '2017' }

      @app.call(env)
    end
  end
end
