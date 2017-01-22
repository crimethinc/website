class Setting < ApplicationRecord
  include Slug

  validates :name, presence: true, uniqueness: true

  def content
    saved_content.blank? ? fallback : saved_content
  end

  def generate_slug
    self.slug = super.gsub("-", "_")
  end
end
