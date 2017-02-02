class Setting < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  before_save :generate_slug

  def content
    saved_content.blank? ? fallback : saved_content
  end

  def generate_slug
    self.slug = name.to_slug.gsub("-", "_")
  end
end
