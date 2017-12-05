module Publishable
  extend ActiveSupport::Concern

  included do
    belongs_to :status
    default_scope { order(published_at: :desc) }

    scope :draft,       -> { where(status: Status.find_by(name: "draft")) }
    scope :published,   -> { where(status: Status.find_by(name: "published")) }
    scope :chronological, -> { order(published_at: :desc) }
    scope :root,          -> { where(collection_id: nil) }
    scope :live,          -> { where("published_at < ?", Time.now) }
    scope :recent,        -> { where("published_at BETWEEN ? AND ?", Time.now - 2.days, Time.now) }
    scope :on,            lambda { |date| where("published_at BETWEEN ? AND ?", date.try(:beginning_of_day), date.try(:end_of_day)) }
    scope :next,          lambda { |article| unscoped.root.where("published_at > ?", article.published_at).live.published.order(published_at: :asc).limit(1) }
    scope :previous,      lambda { |article| root.where("published_at < ?", article.published_at).live.published.chronological.limit(1) }
  end

  def draft?
    status.name == "draft"
  end

  def published?
    status.name == "published"
  end

  def dated?
    published_at.present?
  end
end
