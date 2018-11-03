module Publishable
  extend ActiveSupport::Concern

  included do
    belongs_to :status
    default_scope { order(published_at: :desc) }

    scope :draft,         -> { where(publication_status: 'draft') }
    scope :published,     -> { where(publication_status: 'published') }
    scope :chronological, -> { order(published_at: :desc) }
    scope :root,          -> { where(collection_id: nil) }
    scope :live,          -> { where('published_at < ?', Time.now.utc) }
    scope :recent,        -> { where('published_at BETWEEN ? AND ?', Time.now.utc - 2.days, Time.now.utc) }
    scope :on,            ->(date) { where('published_at BETWEEN ? AND ?', date.try(:beginning_of_day), date.try(:end_of_day)) }
    scope :next,          ->(article) { unscoped.root.where('published_at > ?', article.published_at).live.published.order(published_at: :asc).limit(1) }
    scope :previous,      ->(article) { root.where('published_at < ?', article.published_at).live.published.chronological.limit(1) }
  end

  def draft?
    publication_status == 'draft'
  end

  def published?
    publication_status == 'published'
  end

  def dated?
    published_at.present?
  end
end
