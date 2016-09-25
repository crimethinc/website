class Setting < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  before_validation :generate_slug, on: [:create, :update]

  def content
    saved_content.blank? ? fallback : saved_content
  end

  private

  def generate_slug
    self.slug = self.name.to_slug.gsub("-", "_")
  end
end
