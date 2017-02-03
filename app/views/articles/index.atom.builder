xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.feed "xmlns"     => "http://www.w3.org/2005/Atom",
         "xmlns:thr" => "http://purl.org/syndication/thread/1.0",
         "xml:base"  => request.original_url,
         "xml:lang"  => "en-us" do

  xml.id request.original_url
  xml.link rel: "alternate", type: "text/html",            href: request.original_url.sub("/feed", "")
  xml.link rel: "self",      type: "application/atom+xml", href: request.original_url

  xml.title page_title
  xml.subtitle meta_title(nil)

  xml.link href: "./"
  xml.link rel: "self", href: ""

  xml.logo largest_touch_icon_url
  xml.icon asset_url("icons/favicon.ico")

  xml.updated @articles.first.updated_at.xmlschema

  xml.author do
    xml.name author
    xml.email "help@crimethinc.com"
  end

  @articles.each do |article|
    xml.entry do
      xml.id request.base_url + article.path
      xml.published article.published_at.xmlschema
      xml.updated article.updated_at.xmlschema
      xml.link rel: "alternate", type: "text/html", href: request.base_url + article.path

      xml.title article.name
      xml.summary article.summary

      article.categories.each do |category|
        xml.category scheme: category.name, term: category.name
      end

      article.tags.each do |tag|
        xml.category scheme: tag.name, term: tag.name
      end

      xml.content type: "html" do
        xml.text! [
          figure_image_with_caption_tag(article),
          render_content(article)
        ].join("\n\n")
      end

      article.contributions.each do |contribution|
        xml.contributor do
          xml.name contribution.contributor.name
        end
      end
    end
  end

end
