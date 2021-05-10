module BooksHelper
  def thumbnail_link_to_large_image small_url, large_url = nil
    large_url = small_url.sub('small.', 'large.') if large_url.nil?

    link_to(image_tag(small_url), large_url)
  end

  def button_to_buy_now url: nil
    link_to t('views.tools.buy_now_button_text'), url, class: 'buy-now button'
  end

  def extension_for_ebook type
    case type
    when :epub
      'epub'
    when :mobi
      'mobi'
    else
      'pdf'
    end
  end
end
