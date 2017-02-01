class Setting < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def content
    saved_content.blank? ? fallback : saved_content
  end
end
