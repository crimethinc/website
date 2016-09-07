class SlugValidator < ActiveModel::Validator
  def validate(record)
    if record.new_record? && record.slug_exists?
      record.errors[:slug] << "needs to be unique on the published date"
    end
  end
end

class Article < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  default_scope { order("published_at DESC") }
  scope :on,      lambda { |date| where("published_at BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day) }
  scope :draft,       -> { where(status: "draft") }
  scope :edited,      -> { where(status: "edited") }
  scope :designed,    -> { where(status: "designed") }
  scope :publishable, -> { where(status: "publishable") }
  scope :published,   -> { where(status: "published") }

  before_validation :generate_slug, on: [:create, :update]
  before_validation :generate_published_dates, on: [:create, :update]
  validates_with SlugValidator

  def path
    published_at.strftime("/%Y/%m/%d/#{slug}")
  end

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end

  def slug_exists?
    Article.on(published_at).where(slug: slug).exists?
  end

  private

  def generate_slug
    if self.new_record? || self.slug_changed?
      n = 0
      self.slug = self.name.to_slug

      while slug_exists?
        self.slug = name
        n += 1
        "#{self.slug} #{n}".to_slug
      end
    end
  end

  def generate_published_dates
    self.year  = published_at.year
    self.month = published_at.month.to_s.rjust(2, "0")
    self.day   = published_at.day.to_s.rjust(2, "0")
  end
end
