module FeedHelper
  XML_ENCODING = ::Encoding.find('utf-8')
  require 'builder/xchar'

  def xml_escape(text)
    return if text.blank?

    result = Builder::XChar.encode(text)

    result.encode(XML_ENCODING)
  rescue StandardError
    # if the encoding can’t be supported, use numeric character references
    result
      .gsub(/[^\u0000-\u007F]/) { |c| "&##{c.ord};" }
      .force_encoding('ascii')
  end

  def strip_subdomain url
    url.sub(%r{https://\S*\.*crimethinc.com}, 'https://crimethinc.com')
  end
end
