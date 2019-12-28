# frozen_string_literal: true

class LocaleService
  class << self
    def find locale:, lang_code: nil
      new(locale, lang_code).locale
    end
  end

  def locale
    # This will either find a locale defined in locales.rb, or it will
    # cause an exception to be raised.
    Locales.canonical(locale: locale_name, lang_code: lang_code)
  end

  private

  attr_reader :locale_name, :lang_code

  def initialize locale_name, lang_code
    @lang_code   = normalize_argument(lang_code)&.to_sym
    @locale_name = normalize_argument(locale_name)
  end

  def normalize_argument value
    value.to_s.downcase.strip if value.present?
  end
end

require_relative 'locale_service/locale'
require_relative 'locale_service/locales'
