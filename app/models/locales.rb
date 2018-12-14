class Locales
  SUPPORTED = %i[de en es].freeze

  class << self
    def supported
      SUPPORTED - [I18n.locale]
    end
  end
end
