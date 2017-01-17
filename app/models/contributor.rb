class Contributor < ApplicationRecord
  has_many :articles, through: :contribution
  has_many :contributions, dependent: :destroy

  before_validation :generate_slug, on: [:create, :update]

  validates :slug, presence: true, uniqueness: true

  def bio_rendered
    Kramdown::Document.new(
      bio,
      input: :kramdown,
      remove_block_html_tags: false,
      transliterated_header_ids: true
    ).to_html.html_safe
  end

  def slug_exists?
    Contributor.where(slug: slug).exists?
  end

  private

  def generate_slug
    if self.new_record? || self.slug_changed? || self.slug.blank?
      n = 0

      if slug.blank?
        self.slug = self.name.to_slug
      end

      while slug_exists?
        self.slug = name
        n += 1
        "#{self.slug} #{n}".to_slug
      end
    end

    self.slug = self.slug.to_slug
  end
end
