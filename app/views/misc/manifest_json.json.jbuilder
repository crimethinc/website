json.prettify!

json.lang 'en'
json.short_name t(:site_name)
json.name       t(:site_name)

json.icons icon_sizes.each do |size|
  size_details = {
    src:   asset_url("icons/icon-#{size}x#{size}.png"),
    sizes: "#{size}x#{size}",
    type:  'image/png'
  }

  json.merge! size_details
end

json.start_url        '/'
json.display          'minimal-ui'
json.background_color '#ffffff'
json.theme_color      '#ffffff'
