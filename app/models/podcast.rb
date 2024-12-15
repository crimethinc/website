class Podcast < ApplicationRecord
  include Name
  include Featureable

  has_many :episodes, dependent: :destroy

  validates :slug, presence: true, uniqueness: true

  # hardcoding .published to find all, since Podcast doesn't include Publishable
  scope :published, -> { where.not(id: nil) }

  def path
    "/podcasts/#{slug}"
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end

  def latest_episode
    episodes.live.published.first
  end
end
