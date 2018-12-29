class Video < ApplicationRecord
  include Tool

  include Name
  include Slug
  include Publishable

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings

  # default_scope { order(slug: :asc) }

  def namespace
    'videos'
  end

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
