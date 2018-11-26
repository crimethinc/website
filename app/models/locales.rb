class Locales
  SUPPORTED = %i[de en es].freeze

  class << self
    def supported
      @supported ||= supported_locales
    end

    private

    def supported_locales
      @supported = SUPPORTED - [I18n.locale]
    end
  end
end
