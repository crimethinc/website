module PodcastsHelper
  def subscribe_links_for podcast
    %w[rss itunes overcast pocketcasts].map do |podcatcher|
      link_to(podcatcher_url(podcatcher, podcast), data: { podcatcher: podcatcher }, class: 'u-url') do
        tag.span(class: 'visually-hidden') { t("ui.subscribe_in_#{podcatcher}") }
      end
    end.join.html_safe
  end

  private

  def podcatcher_url podcatcher, podcast
    return podcast_feed_url if podcatcher == 'rss'

    # if a specific podcatcher URL isn't defined, default to the
    # site's /podcasts route
    podcast.send(:"#{podcatcher}_url") || podcasts_url
  end
end
