class Article < ApplicationRecord
  scope :draft,       -> { where(status: "draft") }
  scope :edited,      -> { where(status: "edited") }
  scope :designed,    -> { where(status: "designed") }
  scope :publishable, -> { where(status: "publishable") }
  scope :published,   -> { where(status: "published") }

  def path
    published_at.strftime("/%Y/%m/%d/#{slug}")
  end
end
