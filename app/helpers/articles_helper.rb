module ArticlesHelper
  def live_blog_article?
    @live_blog
  end

  def localizations_for article
    displayable_localizations article
  end

  def displayable_localizations article
    return article.localizations if signed_in?

    article.localizations.select(&:published?)
  end

  def story_card_background_image article:
    "background-image: url(#{article.image})" unless lite_mode?
  end

  def social_links_for article
    tag.ul class: 'social-links' do
      social_link_for(article, :twitter) +
        social_link_for(article, :facebook) +
        social_link_for(article, :tumblr)
    end
  end

  def social_link_for article, site
    url =
      case site
      when :twitter
        "https://twitter.com/intent/tweet?text=#{url_encode article.title}&amp;url=#{article_url}&amp;via=crimethinc"
      when :facebook
        "https://www.facebook.com/sharer?u=#{url_encode article_url}"
      when :tumblr
        [
          'http://tumblr.com/widgets/share/tool?canonicalUrl=',
          article_url,
          '&amp;caption=',
          url_encode(article.title),
          '&amp;content=',
          article.image
        ].join
      end

    tag.li class: 'social-link' do
      link_to "Share on #{site.capitalize}",
              url,
              class:  "link-domain-#{site}",
              target: '_blank',
              rel:    'noopener'
    end
  end

  def figure_image_with_caption_tag article
    return if article.image.blank?

    img        = image_tag article.image, class: 'u-photo', alt: ''
    figcaption = tag.figcaption(article.image_description) if article.image_description.present?

    tag.figure img + figcaption.to_s
  end

  def article_tag(article, &)
    klasses = ['h-entry']
    klasses << 'article-with-no-header-image' if article.image.blank?
    id = "article--#{article.slug}"

    # Data attributes are used to determine how the article should be polled for updates
    data = { id: article.id, published_at: Time.now.utc.to_i }
    data[:listen] = true if article.collection_posts.recent.any?

    tag.article(id: id, class: klasses.join(' '), data: data, &)
  end

  def display_date datetime = nil
    datetime&.strftime('%Y-%m-%d')
  end

  def display_time datetime = nil
    datetime&.strftime('%l:%M')&.html_safe
  end

  def link_to_dates year: nil, month: nil, day: nil, show_year: true, show_month: true, show_day: true
    show_month = false if month.nil?
    show_day   = false if day.nil?

    links = []

    month = month.to_s.rjust(2, '0') unless month.nil?
    day   = day.to_s.rjust(2, '0')   unless day.nil?

    if year && show_year
      links << link_to_unless_current(
        year,
        article_archives_path(year),
        rel:   'archives',
        class: 'year'
      )
    end

    if month && show_month
      links << link_to_unless_current(
        month,
        article_archives_path(year, month),
        rel:   'archives',
        class: 'month'
      )
    end

    if day && show_day
      links << link_to_unless_current(
        day,
        article_archives_path(year, month, day),
        rel:   'archives',
        class: 'day'
      )
    end

    links.join('-').html_safe
  end

  def publication_status_badge_class article
    article.draft? ? 'danger' : 'success'
  end

  def header_image_tag article, width: 2000, height: 1000
    height = width if height.blank?

    placeholder_image_url
    url = article.image
    url = article.header.variant resize_to_limit: [width, height] if article.header.attached?

    image_tag url, class: 'w-100'
  end

  def placeholder_image_url width: 2000, height: 1000
    height = width if height.blank?

    hex_range = (0..9).to_a + ('a'..'f').to_a
    color = [hex_range.sample, hex_range.sample, hex_range.sample].join
    "https://via.placeholder.com/#{width}x#{height}/#{color}?text=+"
  end
end
