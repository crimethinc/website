class Theme
  class << self
    def name
      ENV.fetch('THEME') { '2017' }
    end
  end
end
