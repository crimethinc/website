class Podcast < ApplicationRecord
  include Name
  include Searchable

  has_many :episodes, dependent: :destroy

  validates :slug, presence: true

  def path
    "/podcasts/#{slug}"
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end

  def latest_episode
    episodes.first
  end
end
