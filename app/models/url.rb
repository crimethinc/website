class Url
  TWITTER   = 'https://twitter.com/crimethinc'.freeze
  FACEBOOK  = 'https://facebook.com/CrimethincDotCom'.freeze
  INSTAGRAM = 'https://instagram.com/CrimethincDotCom'.freeze
  EMAIL     = 'mailto:'.freeze
  RSS       = 'https://crimethinc.com/feed'.freeze
  GITHUB    = 'https://github.com/crimethinc'.freeze

  class << self
    def for_share_to site, content:, url:, image:
      case site
      when :twitter
        for_share_to_twitter content: content, url: url
      when :facebook
        for_share_to_facebook content: content, url: url, image: image
      when :tumblr
        for_share_to_tumblr url: url
      when :email
        for_share_to_email content: content, url: url
      end
    end

    def for_share_to_twitter content:, url:
      share_url = ''
      share_url << 'https://twitter.com/intent/tweet'
      share_url << '?text='
      share_url << URI.encode_www_form_component(content)
      share_url << '&via='
      share_url << 'crimethinc'
      share_url << '&url='
      share_url << URI.encode_www_form_component(url)
      share_url
    end

    def for_share_to_facebook content:, url:, image:
      share_url = ''
      share_url << 'https://www.facebook.com/dialog/feed'
      share_url << '?app_id=184683071273'
      share_url << '&link='
      share_url << URI.encode_www_form_component(url)
      share_url << '&picture='
      share_url << URI.encode_www_form_component(image)
      share_url << '&name='
      share_url << URI.encode_www_form_component(content)
      share_url << '&caption='
      share_url << '%20'
      share_url << '&description='
      share_url << URI.encode_www_form_component(content)
      share_url << '&redirect_uri='
      share_url << URI.encode_www_form_component('https://facebook.com')
      share_url
    end

    def for_share_to_tumblr url:
      share_url = ''
      share_url << 'http://tumblr.com/widgets/share/tool'
      share_url << '?canonicalUrl='
      share_url << URI.encode_www_form_component(url)
      share_url
    end

    def for_share_to_email content:, url:
      share_url = ''
      share_url << EMAIL
      share_url << '?subject='
      share_url << I18n.t(:site_name)
      share_url << ' : '
      share_url << URI.encode_www_form_component(content).gsub('+', '%20')
      share_url << '&body='
      share_url << URI.encode_www_form_component(content).gsub('+', '%20')
      share_url << URI.encode_www_form_component("\n\n")
      share_url << URI.encode_www_form_component(url).gsub('+', '%20')
      share_url
    end
  end
end
