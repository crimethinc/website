json.prettify!

json.logo do
  json.WARNING 'WARNING: This JSON API is experimental and subject to change without notice!'
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

  json.attachments do
    json.jpg @tool.image_jpg.attached? ? root_url + url_for(@tool.image_jpg) : nil
    json.png @tool.image_png.attached? ? root_url + url_for(@tool.image_png) : nil
    json.pdf @tool.image_pdf.attached? ? root_url + url_for(@tool.image_pdf) : nil
    json.svg @tool.image_svg.attached? ? root_url + url_for(@tool.image_svg) : nil
    json.tif @tool.image_tif.attached? ? root_url + url_for(@tool.image_tif) : nil
  end
end
