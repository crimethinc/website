class Contributor < ApplicationRecord
  include Slug

  has_many :articles, through: :contribution
  has_many :contributions, dependent: :destroy

  validates :slug, presence: true, uniqueness: true

  def bio_rendered
    Kramdown::Document.new(
      bio,
      input: :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true
    ).to_html.html_safe
  end
end
