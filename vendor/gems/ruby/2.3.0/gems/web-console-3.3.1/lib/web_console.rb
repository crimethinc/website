require 'active_support/dependencies/autoload'
require 'active_support/lazy_load_hooks'
require 'active_support/logger'

module WebConsole
  extend ActiveSupport::Autoload

  autoload :View
  autoload :Evaluator
  autoload :ExceptionMapper
  autoload :Session
  autoload :Response
  autoload :Request
  autoload :WhinyRequest
  autoload :Whitelist
  autoload :Template
  autoload :Middleware

  autoload_at 'web_console/errors' do
    autoload :Error
    autoload :DoubleRenderError
  end

  mattr_accessor :logger
  @@logger = ActiveSupport::Logger.new($stderr)

  ActiveSupport.run_load_hooks(:web_console, self)
end

require 'web_console/railtie'
