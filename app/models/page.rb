class Page < ApplicationRecord
  belongs_to :user, optional: true

  scope :on, lambda { |date| where("published_at BETWEEN ? AND ?", date.try(:beginning_of_day), date.try(:end_of_day)) }

  scope :draft,       -> { where(status: "draft") }
  scope :edited,      -> { where(status: "edited") }
  scope :designed,    -> { where(status: "designed") }
  scope :published,   -> { where(status: "published") }

  before_validation :generate_slug,            on: [:create, :update]
  before_validation :generate_draft_code,      on: [:create, :update]

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end

  def path
    if published?
      slug
    else
      "/drafts/#{self.draft_code}"
    end
  end

  # page states through the process from creation to publishing
  def draft?
    status == "draft"
  end

  def edited?
    status == "edited"
  end

  def designed?
    status == "designed"
  end

  def published?
    status == "published"
  end

  def dated?
    published_at.present?
  end

  private

  def slug_exists?
    Page.on(published_at).where(slug: slug).exists?
  end

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

    path_pieces = self.slug.split("/").reject{ |p| p.blank? }
    self.slug = path_pieces.map{ |piece| piece.to_slug }.join("/")
  end

  def generate_draft_code
    self.draft_code ||= SecureRandom.hex
  end
end
