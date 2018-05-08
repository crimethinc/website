unless Rails.env.development? # To allow breakpoint debugging
  Rack::Timeout.timeout = 20 # seconds
end
