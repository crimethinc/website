# encoding: UTF-8

module Sterile

  class << self

    # Format text with proper "curly" quotes, m-dashes, copyright, trademark, etc.
    #
    #   q{"He said, 'Away with you, Drake!'"}.smart_format # => “He said, ‘Away with you, Drake!’”
    #
    def smart_format(string)
      smart_format_rules.each do |rule|
        string.gsub!(rule[0], rule[1])
      end
      string
    end


    # Like +smart_format+, but works with HTML/XML (somewhat).
    #
    def smart_format_tags(string)
      string.gsub_tags do |text|
        text.smart_format.encode_entities
      end
    end


    private

    # Lazy load smart formatting rules
    #
    def smart_format_rules
      @smart_format_rules ||= begin
        require "sterile/data/smart_format_rules"
        Data.smart_format_rules
      end
    end

  end # class << self

end # module Sterile
