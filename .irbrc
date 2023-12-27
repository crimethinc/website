if defined?(Rails) && Rails.env.local?
  require 'awesome_print'
  AwesomePrint.irb!
end
