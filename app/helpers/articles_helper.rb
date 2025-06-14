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

  def social_share_sites article
    # TODO: change list of social sites
    # TODO: add: mastodon, bluesky, threads
    # TODO: remove: twitter
    url = article_url year:  article.year,
                      month: article.month,
                      day:   article.day,
                      slug:  article.slug

    {
      Email:    "mailto:?subject=#{article.title}",
      Facebook: "https://www.facebook.com/sharer?u=#{url_encode url}",
      Tumblr:   ['http://tumblr.com/widgets/share/tool?canonicalUrl=', url, '&amp;caption=',
                 url_encode(article.title), '&amp;content=', article.image].join
    }
  end

  def social_links_for article
    domains = %i[email bluesky mastodon threads facebook tumblr]

    tag.ul class: 'social-links' do
      domains.map { social_link_for article, it() }.join.html_safe
    end
  end

  def social_link_for article, site
    # TODO: add: mastodon, bluesky, threads
    url = article_url year:  article.year,
                      month: article.month,
                      day:   article.day,
                      slug:  article.slug

    share_url =
      case site
      when :email
        "mailto:?subject=CrimethInc.— #{article.name}&body=#{article.name} #{url_encode url}"
      when :bluesky
        "https://bsky.app/intent/compose?text=#{article.name} #{url_encode url} — @crimethinc.com "
      when :facebook
        "https://www.facebook.com/sharer?u=#{url_encode url}"
      when :mastodon
        "http://mastodon.social/share?text=#{article.name} #{url_encode url}"
      when :threads
        "https://threads.net/intent/post?text=#{article.name} #{url_encode url} — @crimethincredux"
      when :tumblr
        [
          'http://tumblr.com/widgets/share/tool?canonicalUrl=',
          url,
          '&amp;caption=',
          url_encode(article.title),
          '&amp;content=',
          article.image
        ].join
      end

    tag.li class: 'social-link' do
      link_to "Share on #{site.capitalize}",
              share_url,
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

    links.join('–').html_safe
  end

  def publication_status_badge_class article
    article.draft? ? 'danger' : 'success'
  end
end
