class Video < ApplicationRecord
  include Tool

  include Publishable

  def meta_description
    if summary.blank?
      html = Kramdown::Document.new(
        content,
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.to_s

      doc = Nokogiri::HTML(html)
      doc.css('body').text.truncate(200)
    else
      summary
    end
  end

  def meta_image
    ''
  end

  def download_url
    "https://vimeo.com/#{vimeo_id}#download"
  end
end
