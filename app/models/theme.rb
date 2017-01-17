class Theme < ApplicationRecord
  has_many :articles
  before_validation :generate_slug, on: [:create, :update]
  before_validation :strip_whitespace, on: [:create, :update]

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

  def strip_whitespace
    self.name = name.strip
  end

  def slug_exists?
    Theme.where(slug: slug).exists?
  end
end
