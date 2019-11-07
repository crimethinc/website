class PageShare
  include Name

  attr_reader :url, :title, :subtitle, :content, :image_url

  def initialize url:, title:, subtitle:, content:, image_url:
    @url       = url
    @title     = title
    @subtitle  = subtitle
    @content   = content
    @image_url = image_url
  end

  def share_url_for site
    send "share_url_for_#{site}"
  end

  private

  def share_url_for_twitter
    share_url = ''
    share_url << 'https://twitter.com/intent/tweet'
    share_url << '?text='
    share_url << URI.encode_www_form_component(name)
    share_url << '&via='
    share_url << 'crimethinc'
    share_url << '&url='
    share_url << URI.encode_www_form_component(url)
    share_url
  end

  def share_url_for_facebook
    share_url = ''
    share_url << 'https://www.facebook.com/dialog/feed'
    share_url << '?app_id=184683071273'
    share_url << '&link='
    share_url << URI.encode_www_form_component(url)
    share_url << '&picture='
    share_url << URI.encode_www_form_component(image_url)
    share_url << '&name='
    share_url << URI.encode_www_form_component(name)
    share_url << '&caption='
    share_url << '%20'
    share_url << '&description='
    share_url << URI.encode_www_form_component(content)
    share_url << '&redirect_uri='
    share_url << URI.encode_www_form_component('https://facebook.com')
    share_url
  end

  def share_url_for_tumblr
    share_url = ''
    share_url << 'http://tumblr.com/widgets/share/tool'
    share_url << '?canonicalUrl='
    share_url << URI.encode_www_form_component(url)
    share_url
  end

  def share_url_for_email
    share_url = ''
    share_url << 'mailto:'
    share_url << '?subject='
    share_url << I18n.t(:site_name)
    share_url << ' : '
    share_url << URI.encode_www_form_component(name).gsub('+', '%20')
    share_url << '&body='
    share_url << URI.encode_www_form_component(content).gsub('+', '%20')
    share_url << URI.encode_www_form_component("\n\n")
    share_url << URI.encode_www_form_component(url).gsub('+', '%20')
    share_url
  end
end
