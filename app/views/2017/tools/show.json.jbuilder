json.prettify!

json.WARNING 'WARNING: This JSON API is experimental and subject to change without notice!'
json.type @tool.class.to_s.downcase
json.name @tool.name
json.title @tool.title
json.subtitle @tool.subtitle

json.slug @tool.slug
json.path @tool.path
json.url  root_url + @tool.path
json.published_at @tool.published_at.iso8601

json.locale @tool.locale

json.description @tool.description
json.summary @tool.summary

# rubocop:disable Layout/LineLength
json.attachments do
  json.front_color_image @tool.image_front_color_image.attached? ? root_url + url_for(@tool.image_front_color_image) : nil
  json.front_black_and_white_image @tool.image_front_black_and_white_image.attached? ? root_url + url_for(@tool.image_front_black_and_white_image) : nil
  json.back_color_image @tool.image_back_color_image.attached? ? root_url + url_for(@tool.image_back_color_image) : nil
  json.back_black_and_white_image @tool.image_back_black_and_white_image.attached? ? root_url + url_for(@tool.image_back_black_and_white_image) : nil
  json.front_color_download @tool.image_front_color_download.attached? ? root_url + url_for(@tool.image_front_color_download) : nil
  json.front_black_and_white_download @tool.image_front_black_and_white_download.attached? ? root_url + url_for(@tool.image_front_black_and_white_download) : nil
  json.back_color_download @tool.image_back_color_download.attached? ? root_url + url_for(@tool.image_back_color_download) : nil
  json.back_black_and_white_download @tool.image_back_black_and_white_download.attached? ? root_url + url_for(@tool.image_back_black_and_white_download) : nil
end
# rubocop:enable Layout/LineLength
