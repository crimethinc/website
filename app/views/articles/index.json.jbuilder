json.prettify!

json.version        'https://jsonfeed.org/version/1'
json.user_comment   <<~USER_COMMENT
  I support your decision, I believe in change and hope you find just
  what it is that you are looking for. If your heart is free, the
  ground you stand on is liberated territory. Defend it. This feed
  allows you to read the posts from this site in any feed reader that
  supports the JSON Feed format. To add this feed to your reader, copy
  the following URL — https://crimethinc.com/feed.json — and add it
  your reader. For more info on this format: https://jsonfeed.org
USER_COMMENT

json.title          page_title
json.description    meta_title
json.home_page_url  root_url
json.feed_url       json_feed_url
json.next_url       [json_feed_url, '?page=', params[:page].present? ? params[:page].to_i + 1 : 2].join
json.icon           asset_url('icons/icon-600x600.png')
json.favicon        asset_url('icons/icon-70x70.png')

json.author do
  json.name author
  json.url  root_url
  json.avatar asset_url('icons/icon-600x600.png')
end

json.items do
  json.array! @articles.each do |article|
    json.id  root_url + article.path
    json.url root_url + article.path
    json.title article.name
    json.summary article.summary
    json.image article.image
    json.banner_image article.image
    json.date_published article.published_at.to_formatted_s(:iso8601)
    json.date_modified article.updated_at.to_formatted_s(:iso8601)
    json.tags article.tags.map(&:name).compact
    json.content_html article.content_rendered(include_media: media_mode?)
  end
end
