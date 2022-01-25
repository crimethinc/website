json.prettify!

json.version        'https://jsonfeed.org/version/1'
json.user_comment   <<~USER_COMMENT.squish
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
json.feed_url       "#{root_url}/#{controller_path}.json"

json.feed_url       "#{root_url}/#{controller_path}.json"

next_path           = path_to_next_page @tools
previous_path       = path_to_previous_page @tools
json.next_url       "#{root_url}#{next_path}" if next_path.present?
json.previous_url   "#{root_url}#{previous_path}" if previous_path.present?

json.icon           asset_url('icons/icon-600x600.png')
json.favicon        asset_url('icons/icon-70x70.png')

json.author do
  json.name author
  json.url  root_url
  json.avatar asset_url('icons/icon-600x600.png')
end

json.items do
  json.array! @tools.each do |tool|
    json.id  root_url + tool.path
    json.url root_url + tool.path
    json.title tool.name
    json.summary tool.summary
    json.image tool.image
    json.date_published tool.published_at.iso8601
    json.date_modified tool.updated_at.iso8601
    json.tags tool.tags.filter_map(&:name)
    json.lang tool.locale
  end
end
